require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

require "capybara/rails"
require "capybara/rspec"
require "capybara-screenshot/rspec"
require "site_prism"

# For performance testing
require "benchmark"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

if ENV["BROWSER"] == "selenium"
  Capybara.default_driver = :selenium
elsif ENV["BROWSER"] == "chrome"
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
  Capybara.default_driver = :chrome
else
  require "capybara/poltergeist"
  Capybara.default_driver = :poltergeist
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.use_transactional_fixtures = false

  config.include FactoryGirl::Syntax::Methods

  config.include PlanHelpers, type: :feature
  config.include ClassroomHelpers, type: :feature
  config.include InventoryStateHelpers, type: :feature
  config.include SchoolHelpers, type: :feature
  config.include BookBagHelpers, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = "random"
end
