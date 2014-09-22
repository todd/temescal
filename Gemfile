source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'rake'
  gem 'pry-byebug', '~> 2.0.0'
  gem 'awesome_print'
end

group :test do
  gem 'rspec', '~> 3.1'
  gem 'simplecov', require: false

  gem 'activerecord', '>= 3.2'
  gem 'sinatra', '~> 1.4'

  # Monitor Gems
  gem 'airbrake', '~> 4.1'
  gem 'newrelic_rpm', '~> 3.9'
  gem 'bugsnag', '~> 2.5'
  gem 'honeybadger', '~> 1.16'
end
