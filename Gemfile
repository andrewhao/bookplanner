source "https://rubygems.org"
ruby "2.2.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "4.1.6"

gem "pg"

# Use SCSS for stylesheets
gem "sass-rails", "~> 4.0.2"

# Use HAML templating language.
gem "haml-rails"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Use CoffeeScript for .js.coffee assets and views
gem "coffee-rails", "~> 4.0.0"

# Use jquery as the JavaScript library
gem "jquery-rails"

source "https://rails-assets.org" do
  gem "rails-assets-bootstrap"
  gem "rails-assets-jquery.tablesorter"
  gem "rails-assets-lodash"
end

gem "hashdiff"
gem "foreman"
gem "newrelic_rpm"
gem "simple_form", github: "plataformatec/simple_form"
gem "paranoia", "~> 2.0"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 1.2"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", require: false
end

# Use ActiveModel has_secure_password
gem "bcrypt-ruby", "~> 3.0.0"

gem "active_model_serializers"

# Use unicorn as the app server
gem "unicorn"

gem "amb", "~>0.0.5"

# Allow out-of-domain requests.
gem "rack-cors", require: "rack/cors"

gem "rails_12factor", group: :production

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  # Use Capistrano for deployment
  gem "spring"
  gem "capistrano"
  gem "rubocop"
  gem "guard-rspec", require: false
end

group :test do
  gem "fuubar"
  gem "capybara-screenshot"
  gem "factory_girl_rails", "~> 4.0"
  gem "codeclimate-test-reporter"
  gem "rspec-rails", "~>3.1"
  gem "rspec", "~>3.1"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "minitest"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
  gem "capybara"
  gem "site_prism"
  gem "poltergeist"
  gem "rspec-prof", github: "sinisterchipmunk/rspec-prof"
end

group :development, :test do
  gem "faker"
  gem "railroady"
  gem "awesome_print"
  # Use debugger
  # gem 'debugger'
  gem "pry"
  gem "pry-byebug"
end
