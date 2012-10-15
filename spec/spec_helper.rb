require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  require 'simplecov'
  SimpleCov.start 'rails'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'shoulda/matchers/integrations/rspec'
  Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    config.before :each, :type => :controller do
      request.env['HTTPS'] = 'on'
    end
  end
end

Spork.each_run do
  FactoryGirl.reload
end
