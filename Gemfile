# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

gem "uglifier"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "dotenv-rails"

# Pagination
gem "kaminari"

# For reordering list
gem "acts_as_list"

# For compiling and bundling JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker"

gem "react-rails"

# versioning
gem "paper_trail"

gem "sidekiq", "<7"

# For periodic sidekiq jobs
gem "sidekiq-cron"

# PDF generation gem
gem "wicked_pdf"

# wicked_pdf uses the following binary
gem "wkhtmltopdf-binary"

# Required by Active Storage to use the GCS
gem "google-cloud-storage"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # For code formatting and linting
  gem "rubocop", require: false
  gem "rubocop-rails", require: false

  # Rails integration for factory_bot, a replacement for fixtures
  gem "factory_bot_rails"

  # For auto-generating demo data
  gem "faker"

  gem "byebug"

  # For cleaning the database
  gem "database_cleaner"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # For linting ERB files
  gem "erb_lint", require: false, git: "https://github.com/Shopify/erb-lint.git", branch: "main"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem "simplecov", require: false
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
end
