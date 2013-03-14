log_dir = File.expand_path('../../log', __FILE__)

set :job_template, "/usr/bin/env bash -l -i -c ':job' 1>#{log_dir}/schedule.log 2>#{log_dir}/schedule-errors.log"

every :day do
  rake 'cron'
end
