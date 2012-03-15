source :rubygems

gem 'acts_as_list',                               :git => 'git://github.com/swanandp/acts_as_list'
gem 'attribute_normalizer'
gem 'configliere'
gem 'curb'
gem 'el_vfs_client'
gem 'esp-auth'
gem 'esp-ckeditor'
gem 'esp-commons'
gem 'esp-gems'
gem 'fog',                                        :require => false
gem 'gilenson'
gem 'hashie'
gem 'jquery-rails'
gem 'nested_form'
gem 'rails'
gem 'sanitize'
gem 'sass-rails'
gem 'show_for'
gem 'simple-navigation'

group :assets do
  gem 'compass-rails'
  gem 'uglifier'
end

group :development do
  gem 'hirb',                                     :require => false
  gem 'itslog'
  gem 'sunspot_solr'
  gem 'therubyracer'                              unless RUBY_PLATFORM =~ /freebsd/
end

group :test do
  gem 'fabrication',                              :require => false
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'libnotify'
  gem 'rb-inotify'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spork'
  gem 'sqlite3'
  gem 'sunspot_matchers',                         :require => false
end

group :production do
  gem 'hoptoad_notifier'
  gem 'unicorn',                                  :require => false unless ENV['SHARED_DATABASE_URL']
end
