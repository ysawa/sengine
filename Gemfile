source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Database ORM: Mongoid
gem 'mongoid', '~> 2.4'
gem 'bson_ext', '~> 1.5'

# Use Devise to authenticate users
gem 'devise'
gem 'omniauth-facebook'

# Use The Decorator Pattern
gem 'draper', '0.11.1'

# Pagination
gem 'kaminari'

# Pjax
gem 'pjax_rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

# Use JQuery to improve JavaScript development
gem 'jquery-rails'

# Haml
gem 'haml'
gem 'haml-rails'

# Borbon Sass Plugin
gem 'bourbon'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  gem 'thin'
end

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.3', require: false
  # gem 'capybara-webkit', '0.8.0'
end

group :development, :test do
  gem 'fakeweb', '1.3.0'
  gem 'rspec-rails', '2.8.1'
  gem 'spork', '1.0.0rc1'
  gem 'capybara', '1.1.2'
  gem 'fabrication', '1.2.0'
  gem 'rb-fsevent', '0.4.0'
  gem 'launchy', '2.0.5'
  gem 'guard-spork', '0.5.1'
  gem 'guard-rspec', '0.6.0'
end
