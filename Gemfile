source 'http://rubygems.org'

gem 'rails'

gem 'haml-rails'
gem 'uuidtools'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'dynamic_form'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'raphael-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'spork'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'simplecov'
end

group :development do
  gem 'mongrel', '1.2.0.pre2'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'jasmine'
  gem 'faker'
  gem 'rails_best_practices'
end
