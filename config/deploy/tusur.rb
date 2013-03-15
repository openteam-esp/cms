settings_yml_path = "config/deploy.yml"
config = YAML::load(File.open(settings_yml_path))
raise 'not found deploy key in deploy.yml. see deploy.yml.example' unless config['deploy']
application = config['deploy']['tusur']['application']
raise 'not found deploy.application key in deploy.yml. see deploy.yml.example' unless application
domain = config['deploy']['tusur']['domain']
raise 'not found deploy.domain key in deploy.yml. see deploy.yml.example' unless domain
gateway = config['deploy']['tusur']['gateway']
raise 'not found deploy.gateway key in deploy.yml. see deploy.yml.example' unless gateway
pg_domain = config['deploy']['tusur']['pg_domain']
raise 'not found deploy.pg_domain key in settings.yml. see settings.yml.example' unless domain

set :application, application
set :domain, domain
set :gateway, gateway
set :pg_domain, pg_domain

set :ssh_options, { :forward_agent => true }
set :default_shell, "bash -l"

set :rails_env, "production"
set :deploy_to, "/srv/#{application}"
set :use_sudo, false
set :unicorn_instance_name, "unicorn"

set :scm, :git
set :repository, "git://github.com/openteam-esp/cms.git"
set :branch, "bye_bye_contexts"
set :deploy_via, :remote_cache

set :repository_cache, "cached_copy"

set :keep_releases, 7

set :bundle_gemfile,  "Gemfile"
set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
set :bundle_flags,    "--deployment --quiet --binstubs"
set :bundle_without,  [:development, :test]

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# remote database.yml
database_yml_path = "config/database.yml"
config = YAML::load(capture("cat #{deploy_to}/shared/#{database_yml_path}"))
adapter = config[rails_env]["adapter"]
database = config[rails_env]["database"]
db_username = config[rails_env]["username"]
host = config[rails_env]["host"]

#local database.yml
config = YAML::load(File.open(database_yml_path))
local_rails_env = 'development'
local_adapter = config[local_rails_env]["adapter"]
local_database = config[local_rails_env]["database"]
local_db_username = config[local_rails_env]["username"]

set :timestamp, Time.now.strftime("%Y-%m-%d-%H-%M")
namespace :db do
  desc "download data to local database"
  task :import do
    run_locally("bin/rake db:drop")
    run_locally("bin/rake db:create")
    run_locally("ssh #{gateway} -At ssh #{domain} pg_dump -U #{db_username} #{database} -h #{host} -O | psql #{local_database}")
    run_locally("bin/rake db:migrate RAILS_ENV=test")
    run_locally("bin/rake db:migrate")
  end
end

namespace :deploy do
  desc "Copy config files"
  task :config_app, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Copy unicorn.rb file"
  task :copy_unicorn_config do
    run "mv #{release_path}/config/unicorn.rb #{release_path}/config/unicorn.rb.example"
    run "ln -s #{deploy_to}/shared/config/unicorn.rb #{release_path}/config/unicorn.rb"
  end

  desc "Reload Unicorn"
  task :reload_servers do
    sudo "/etc/init.d/nginx reload"
    sudo "/etc/init.d/#{unicorn_instance_name} restart"
  end

  desc "Update crontab tasks"
  task :crontab do
    run "cd #{release_path} && exec bundle exec whenever --update-crontab --load-file #{release_path}/config/schedule.rb"
  end

  desc "Airbrake notify"
  task :airbrake do
    run "cd #{release_path} && RAILS_ENV=production TO=production bin/rake airbrake:deploy"
  end
end

namespace :subscriber do
  desc "Start rabbitmq subscriber"
  task :start do
    run "#{release_path}/script/subscriber -e production start"
  end

  desc "Stop rabbitmq subscriber"
  task :stop do
    run "#{release_path}/script/subscriber stop"
  end
end

# stop subscribers
before "deploy", "subscriber:stop"

# deploy
after "deploy:finalize_update", "deploy:config_app"
after "deploy", "deploy:migrate"
after "deploy", "deploy:copy_unicorn_config"
after "deploy", "deploy:reload_servers"
after "deploy", "subscriber:start"
after "deploy:restart", "deploy:cleanup"
after "deploy", "deploy:crontab"
after "deploy", "deploy:airbrake"

# deploy:rollback
after "deploy:rollback", "deploy:reload_servers"
after "deploy:rollback", "subscriber:start"
