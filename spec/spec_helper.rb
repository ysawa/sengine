# -*- coding: utf-8 -*-

require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'

  Capybara.javascript_driver = :webkit

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.before(:each) do
      FakeWeb.allow_net_connect = %r[^https?://(localhost|127\.0\.0\.1)]
      Mongoid.session(:default).collections.each do |collection|
        collection.drop
      end
    end

    config.after(:each) do
      # remove all tmp files created by CarrierWave
      tmp_directory = File.join(Rails.root, "public/uploads/tmp")
      FileUtils.rm_rf(tmp_directory) if File.directory?(tmp_directory)
      FakeWeb.clean_registry
    end

    # To test features using authentication
    %w(controller decorator view).each do |type|
      config.include Devise::TestHelpers, type: type.to_sym
      config.include DeviseAuthenticationHelper, type: type.to_sym
    end

    %w(decorator request view).each do |type|
      config.include IntegrationTestHelper, type: type.to_sym
    end

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = false
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
