# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mets_converter/version'

Gem::Specification.new do |spec|
  spec.name          = 'mets_converter'
  spec.version       = MetsConverter::VERSION
  spec.authors       = ['Brendan Quinn']
  spec.email         = ['brendan-quinn@northwestern.edu']

  spec.summary       = 'Converts METS schema encoded XML to YML'
  spec.description   = 'Converts METS schema encoded XML to YML'
  spec.homepage      = 'https://github.com/nulib/mets_converter'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'nokogiri', '>= 1.7.1'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
