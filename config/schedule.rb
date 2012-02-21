set :job_template, "/usr/local/bin/bash -l -c ':job'" if RUBY_PLATFORM =~ /freebsd/

every 1.day, :at => '4:00 am' do
    rake 'esp_auth:sync'
end
