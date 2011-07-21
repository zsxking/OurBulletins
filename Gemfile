source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'amazon-ecs'

# Asset template engines
gem 'jquery-rails'
gem 'haml'
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

gem 'devise'

gem 'indextank'
#gem 'tanker'

gem 'kaminari'
gem 'gravatar_image_tag'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  gem 'rspec-rails'
  gem 'annotate'
#  gem 'hirb'
end

group :test do
  gem 'simplecov'
  gem 'rspec'
  gem 'webrat'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'faker'
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  # Memcache client
  gem 'dalli'
  # Use unicorn as the web server
  gem 'unicorn'
  gem 'therubyracer-heroku', '0.8.1.pre3'
end
