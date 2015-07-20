# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adequate_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = 'adequate_serializer'
  spec.version       = AdequateSerializer::VERSION
  spec.authors       = ['Bastian Bartmann']
  spec.email         = ['bastian.bartmann@netflower.de']

  spec.summary       = %q{A very opinionated lightweight serializer.}
  spec.description   = %q{A very opinionated lightweight serializer.}
  spec.homepage      = 'https://github.com/netflower/adequate_serializer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
end
