# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gollum/auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'gollum-auth'
  spec.version       = Gollum::Auth::VERSION
  spec.authors       = ['Björn Albers']
  spec.email         = ['bjoernalbers@gmail.com']

  spec.summary       = "#{spec.name}-#{spec.version}"
  spec.description   = 'Authentication Middleware for Gollum Wiki'
  spec.homepage      = 'https://github.com/bjoernalbers/gollum-auth'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'activemodel'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'factory_bot', '~> 4.8'
  spec.add_development_dependency 'faker', '~> 1.7'
end
