source "https://rubygems.org"

gem "rails", "7.2.1"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "rack-cors"
gem "bcrypt"
gem 'redis', '~> 5.0'
gem 'redis-clustering'
gem "activesupport", "7.2.1"
gem "sidekiq"
gem "bootsnap", require: false
gem "kamal", require: false
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "dotenv-rails"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rspec-rails", "~> 7.0.0"
  gem "factory_bot_rails"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
