current_dir = File.expand_path('../..', __FILE__)

project = current_dir.split('/').last

settings = YAML.load_file "#{current_dir}/config/settings.yml"

settings['unicorn'] ||= {}
settings['unicorn']['workers'] ||= 2
settings['unicorn']['preload'] = true if settings['unicorn']['preload'] != false
settings['unicorn']['timeout'] ||= 300

settings['unicorn']['logs_dir'] ||= "/var/log/esp/#{project}"
settings['unicorn']['pids_dir'] ||= '/var/run/esp'
settings['unicorn']['socks_dir'] ||= '/tmp'
unless settings['unicorn']['socks_dir'].start_with? "/"
  settings['unicorn']['socks_dir'] = "#{current_dir}/#{settings['unicorn']['socks_dir']}"
end

worker_processes  settings['unicorn']['workers']
preload_app       settings['unicorn']['preload']
timeout           settings['unicorn']['timeout']
listen            settings['unicorn']['listen'] if settings['unicorn']['listen']
listen            "#{settings['unicorn']['socks_dir']}/esp-#{project}.sock", :backlog => 64
pid               "#{settings['unicorn']['pids_dir']}/#{project}.pid"
stderr_path       "#{settings['unicorn']['logs_dir']}/stderr.log"
stdout_path       "#{settings['unicorn']['logs_dir']}/stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
