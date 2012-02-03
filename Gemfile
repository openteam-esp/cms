source :rubygems

gem 'acts_as_list',                               :git => 'git://github.com/swanandp/acts_as_list'
gem 'ancestry'
gem 'attribute_normalizer'
gem 'compass',                  '~> 0.12.alpha'
gem 'configliere'
gem 'curb'
gem 'default_value_for'
gem 'el_vfs_client'
gem 'esp-ckeditor'
gem 'fog',                                        :require => false
gem 'formtastic'
gem 'gilenson'
gem 'has_enum'
gem 'hashie'
gem 'inherited_resources'
gem 'jquery-rails'
gem 'nested_form',                                :git => 'git://github.com/kfprimm/nested_form'
gem 'rails'
gem 'russian'
gem 'sanitize'
gem 'sass-rails'
gem 'show_for'
gem 'simple-navigation'

group :assets do
  gem 'uglifier'
end

group :development do
  gem 'annotate',               '~> 2.4.1.beta1', :require => false
  gem 'hirb',                                     :require => false
  gem 'itslog'
  gem 'therubyracer'                              unless RUBY_PLATFORM =~ /freebsd/
end

group :test do
  gem 'fabrication',                              :require => false
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'libnotify'
  gem 'rb-inotify'
  gem 'rspec-rails',            '~> 2.6.0'
  gem 'shoulda-matchers'
  gem 'spork',                  '~> 0.9.0.rc9'
  gem 'sqlite3'
end

group :production do
  gem 'hoptoad_notifier'
  gem 'pg',                                       :require => false
  gem 'unicorn',                                  :require => false unless ENV['SHARED_DATABASE_URL']
end
