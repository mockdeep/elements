source 'http://rubygems.org'

gem 'rails', '3.2.2'

gem 'haml-rails'
gem 'uuidtools'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'dynamic_form'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
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
  gem 'faker'
end

group :development do
  gem "mongrel", '1.2.0.pre2'
end

group :test, :development do
  gem "rspec-rails", "~> 2.6"
  gem 'jasmine'
end
