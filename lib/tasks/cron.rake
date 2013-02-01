desc 'Execute periodical tasks'
task :cron do
  task(:reindex_parts).invoke("GpoProjectListPart")
end
