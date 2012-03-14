require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'fabrication'
  require "cancan/matchers"
  require 'esp_auth/spec_helper'
  require 'sunspot_matchers'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.include AttributeNormalizer::RSpecMatcher
    config.include Devise::TestHelpers, :type => :controller
    config.include EspAuth::SpecHelper

    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.before :all do
      Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
    end
  end
end

Spork.each_run do
end

