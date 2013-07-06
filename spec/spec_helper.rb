ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'rspec/rails'
require 'factory_girl'
require 'capybara/rails'
require 'rake'

FactoryGirl.find_definitions

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  require 'carrierwave/test/matchers'
  require 'rails/generators'
  

  config.include RSpec::Matchers
  config.include CarrierWave::Test::Matchers
  config.include KuhsaftSpecHelper
  config.include FactoryGirl::Syntax::Methods

  config.before :suite do

    load File.expand_path("../dummy/Rakefile", __FILE__)
    Dir.chdir(File.join(File.dirname(__FILE__), './dummy')) do
      Rake::Task['kuhsaft:install:migrations'].invoke
      Rails::Generators.invoke('kuhsaft:install:assets')
    end

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    # Drop all records and run any available migration
    ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
    ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)
  end

  config.after :suite do
    # remove migrations?
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  # == Mock Framework
  config.mock_with :rspec
  config.use_transactional_fixtures = false
end
