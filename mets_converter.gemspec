# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mets_converter/version'

Gem::Specification.new do |spec|
  spec.name          = 'mets_converter'
  spec.version       = MetsConverter::VERSION
  spec.license       = 'Apache-2.0'
  spec.authors       = ['Brendan Quinn']
  spec.email         = ['brendan-quinn@northwestern.edu']

  spec.summary       = 'Converts METS schema encoded XML to YML'
  spec.description   = 'Converts METS schema encoded XML to YML'
  spec.homepage      = 'https://github.com/nulib/mets_converter'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = ["mets_to_yaml"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '>= 1.10.4'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
