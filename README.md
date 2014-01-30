temescal
========

[![Gem Version](https://badge.fury.io/rb/temescal.png)](http://badge.fury.io/rb/temescal) [![Build Status](https://travis-ci.org/todd/temescal.png?branch=master)](https://travis-ci.org/todd/temescal) [![Coverage Status](https://coveralls.io/repos/todd/temescal/badge.png?branch=master)](https://coveralls.io/r/todd/temescal?branch=master) [![Code Climate](https://codeclimate.com/github/todd/temescal.png)](https://codeclimate.com/github/todd/temescal) [![Dependency Status](https://gemnasium.com/todd/temescal.png)](https://gemnasium.com/todd/temescal)

Temescal is Rack middleware that will automatically rescue exceptions for JSON APIs and render a nice, clean JSON response with the error information. No need to write custom error handling logic for your apps - Temescal will take care of it for you!
## Getting Started
Add the gem to your Gemfile and run `bundle install`:
```
gem 'temescal'
```
Since Temescal is just Rack middleware, adding it to your application is super easy. For Rails, add an initializer:
```ruby
Rails.application.config.middleware.use Temescal::Middleware do |config|
  config.monitors = :airbrake, :new_relic
  config.default_message = "Oops! Something went kablooey!"
end
```
For Sinatra:
```ruby
use Temescal::Middleware do |config|
  config.monitors = :airbrake, :new_relic
  config.default_message = "Oops! Something went kablooey!"
end
```
## Default Behavior
By default, Temescal will render a JSON response formatted as such (using StandardError with a message of "Foobar" as an example):
```json
{
  meta: {
    status: 500,
    error: "StandardError",
    message: "Foobar"
  }
}
```
Temescal will also log the error for you through STDERR.
## Monitors
Though Temescal will log an error for you, it won't necessarily be picked up by your monitoring solution of choice in a production environment. Luckily, Temescal provides integration with popular monitoring services. At the moment, only two (Airbrake, New Relic) are supported, but more will be added if there's a need. If you use a different monitoring service that you'd like to see supported, pull requests are more than welcome!

Note that you'll need the gem for your monitor installed and configured for your application in order for Temescal to properly work with it.

## Configuration
Temescal provides several configuration options for you. You can set these options when configuring the middleware for your application.

`monitors` to set the monitors you'd like to use with Temescal. It takes symbols of monitor names (currently `:airbrake` and `:new_relic`).

`raise_errors` to set whether you'd like to override Temescal and raise all errors without rendering a Temescal response. Set to `true` to enable.

`default_message` to set an all-encompasing message to use in responses instead of the exception's message. Takes a string.

`ignored_errors` to set which exception types you'd like to not be reported to a monitor or logged. Specified errors will still have error responses built, but they won't trigger any sort of logging. It takes the class names of the exceptions you'd like ignored.

## License
Copyright 2013-2014 Todd Bealmear. See LICENSE for details.
