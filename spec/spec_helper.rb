require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'fabrication'
  require "cancan/matchers"
  require 'sunspot_matchers'
  require 'esp_auth/spec_helper'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.include AttributeNormalizer::RSpecMatcher
    config.include Devise::TestHelpers, :type => :controller
    config.include EspAuth::SpecHelper
    config.include EspCmsHelper

    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.before :all do
      Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
    end

    config.before do
      MessageMaker.stub(:make_message)

      stub_sites_yml_for_all_nodes
      stub_blue_page_response
    end
  end
end

Spork.each_run do
end

