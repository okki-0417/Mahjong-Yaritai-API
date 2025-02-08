source "https://rubygems.org"

gem "rails", "7.2.1"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "rack-cors"
gem "bcrypt"
gem 'redis-rails'
gem "sidekiq"
gem "bootsnap", require: false
gem "kamal", require: false
gem "image_processing", "~> 1.2"
gem 'dotenv-rails'

group :production do
  gem "redis-clustering"
end

group :development do
  gem "letter_opener_web"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
end

group :development, :test do
  gem "rspec-rails", "~> 7.0.0"
  gem "debug"
  gem "factory_bot_rails"
end
