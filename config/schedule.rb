log_dir       = File.expand_path('../../log', __FILE__)
path_to_bash  = (RUBY_PLATFORM =~ /freebsd/) ? '/usr/local/bin/bash' : '/bin/bash'

set :job_template, "#{path_to_bash} -l -i -c ':job' 1>>#{log_dir}/schedule.log 2>>#{log_dir}/schedule-errors.log"

every :day do
  rake 'cron'
end
