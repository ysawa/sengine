source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Database ORM: Mongoid
gem 'mongoid'

# Use Devise to authenticate users
gem 'devise'
gem 'omniauth-facebook'

# Use The Decorator Pattern
gem 'draper'

# Pagination
gem 'kaminari'

gem 'httpclient'

# Pjax
# gem 'pjax_rails'
gem 'rack-pjax'

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
gem 'sass'

# Borbon Sass Plugin
gem 'bourbon'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'jpmobile'

# Resque to process delayed jobs
gem 'resque'
gem 'resque-scheduler', require: 'resque_scheduler'

group :development do
  gem 'thin'
end

group :test do
  # Pretty printed test output
  gem 'turn', require: false
  gem 'capybara-webkit' if RUBY_PLATFORM =~ /darwin/i # mac os x
end

group :development, :test do
  gem 'fakeweb'
  gem 'rspec-rails'
  gem 'spork', '1.0.0rc3'
  gem 'capybara'
  gem 'fabrication'
  gem 'rb-fsevent', require: false if RUBY_PLATFORM =~ /darwin/i # mac os x
  gem 'launchy'
  gem 'guard-spork'
  gem 'guard-rspec'

  # Notifiers
  case RUBY_PLATFORM
  when /linux/i
    gem 'libnotify'
  when /darwin/i
    gem 'growl'
  when /mswin(?!ce)|mingw|cygwin|bccwin/i
    gem 'rb-notifu'
  end
end

# Deploy with Capistrano
group :deployment do
  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'rvm-capistrano'
end
