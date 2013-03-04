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
    run_locally("ssh #{gateway} -At ssh #{domain} pg_dump -U #{db_username} #{database} -h #{pg_domain} -O | psql #{local_database}")
    run_locally("bin/rake db:migrate RAILS_ENV=test")
    run_locally("bin/rake db:migrate")
  end
end
