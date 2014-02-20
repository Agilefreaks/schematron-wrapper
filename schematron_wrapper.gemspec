# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schematron/version'

Gem::Specification.new do |spec|
  spec.name          = 'schematron-wrapper'
  spec.version       = Schematron::VERSION

  spec.authors       = ['AgileFreaks']
  spec.email         = ['office@agilefreaks.com']
  spec.description   = 'A ruby gem that wrappers various schematron implementations so they can be easily used in ruby'

  spec.homepage      = 'https://github.com/Agilefreaks/schematron-wrapper'
  spec.require_paths = ['lib']
  spec.rubygems_version = '1.0.0'
  spec.summary       = 'Schematron XSLT 2.0 validator using Saxon9-HE'
  
  spec.license       = 'Mozilla Public License, version 2.0'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency 'nokogiri'
end
