source :rubygems

group :assets do
  gem 'libv8'                                     unless RUBY_PLATFORM =~ /freebsd/
  gem 'therubyracer'                              unless RUBY_PLATFORM =~ /freebsd/
  gem 'uglifier'
end

group :default do
  gem 'acts_as_list'
  gem 'ancestry'
  gem 'attribute_normalizer'
  gem 'audited-activerecord'
  gem 'compass-rails'
  gem 'default_value_for'
  gem 'devise-russian'
  gem 'el_vfs_client'
  gem 'esp-ckeditor'
  # TODO: remove git source when rubygems   up publish API
  gem 'esp-commons',    :git => 'git://github.com/openteam-esp/esp-commons'
  gem 'esp-views'
  gem 'formtastic',     '< 2.2.0'
  gem 'gilenson'
  gem 'has_enum'
  gem 'hashie'
  gem 'inherited_resources'
  gem 'jquery-rails'
  gem 'nested_form'
  gem 'rails'
  gem 'russian'
  gem 'sanitize'
  gem 'sass-rails'
  gem 'show_for'
  gem 'simple-navigation'
  gem 'sso-auth'
end

group :development do
  gem 'annotate'
  gem 'hirb',                                     :require => false
  gem 'rvm-capistrano'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'fabrication',      '< 2.0.0',              :require => false
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'sqlite3'
end
