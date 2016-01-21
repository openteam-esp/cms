require 'openteam/capistrano/recipes'

set :shared_children, fetch(:shared_children) + %w[tmp/rack-cache]
