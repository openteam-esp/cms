desc 'Execute periodical tasks'
task :cron => 'esp_auth:sync'
