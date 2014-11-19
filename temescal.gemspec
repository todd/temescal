# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'temescal/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'rack', '~> 1.0'
  spec.add_development_dependency 'bundler', '~> 1.0'

  spec.authors       = ['Todd Bealmear']
  spec.description   = %q{Rack Middleware for gracefully handling exceptions for JSON APIs.}
  spec.email         = ['todd@t0dd.io']
  spec.files         = %w(LICENSE README.md Rakefile temescal.gemspec)
  spec.files        += Dir.glob('lib/**/*.rb')
  spec.files        += Dir.glob('spec/**/*')
  spec.homepage      = 'https://github.com/todd/temescal'
  spec.licenses      = ['MIT']
  spec.name          = 'temescal'
  spec.require_paths = ['lib']
  spec.summary       = spec.description
  spec.version       = Temescal::VERSION
end
