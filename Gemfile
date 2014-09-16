source 'https://rubygems.org'

gemspec

gem 'rake'

# Monitor Gems
gem 'airbrake', '~> 4.1'
gem 'newrelic_rpm', '~> 3.9'
gem 'bugsnag', '~> 2.4'
gem 'honeybadger', '~> 1.16'

group :development, :test do
  gem 'pry-byebug', '~> 2.0.0'
  gem 'awesome_print'
end

group :test do
  gem 'rspec', '~> 3.1'
  gem 'simplecov', require: false

  gem 'activerecord', '>= 3.2'
  gem 'sinatra', '~> 1.4'
end
