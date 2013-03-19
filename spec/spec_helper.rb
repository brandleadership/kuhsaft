require 'spork'

Spork.prefork do
  # Configure Rails Envinronment
  ENV["RAILS_ENV"] = "test"

  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require "rails/test_help"
  require "rspec/rails"
  require 'factory_girl'
  require "capybara/rails"
  require 'factories'
  require 'generators/kuhsaft/install/migrations_generator'

  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.default_url_options[:host] = "test.com"

  Rails.backtrace_cleaner.remove_silencers!

  # Configure capybara for integration testing
  Capybara.default_driver   = :rack_test
  Capybara.default_selector = :css

  # Drop all records and run any available migration
  Rails::Generators.invoke 'kuhsaft:install:migrations'
  
  ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
  ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

  # Load support files
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
  
  Kuhsaft::Page.translation_locales = [:en, :de]
  Kuhsaft::Page.current_translation_locale = :en

  RSpec.configure do |config|
    # Remove this line if you don't want RSpec's should and should_not
    # methods or matchers
    require 'rspec/expectations'
    require 'carrierwave/test/matchers'
    
    config.include RSpec::Matchers
    config.include CarrierWave::Test::Matchers
    config.include KuhsaftSpecHelper

    # == Mock Framework
    config.mock_with :rspec
    config.use_transactional_fixtures = true
  end
end

Spork.each_run do

end
