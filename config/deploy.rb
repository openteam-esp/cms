require 'openteam/capistrano/deploy'

set :bundle_binstubs, -> { shared_path.join('bin') }

append :linked_dirs, 'tmp/rack-cache'

set :db_remote_clean, true

set :slackistrano,
  channel: (Settings['slack.channel'] rescue ''),
  webhook: (Settings['slack.webhook'] rescue '')
