# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-scaleway/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-scaleway'
  spec.version       = VagrantPlugins::Scaleway::VERSION
  spec.authors       = ['Satoshi Matsumoto']
  spec.email         = ['kaorimatz@gmail.com']

  spec.summary       = 'Vagrant provider plugin for Scaleway'
  spec.description   = 'Enables Vagrant to manage machines in Scaleway.'
  spec.homepage      = 'https://github.com/kaorimatz/vagrant-scaleway'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'fog-scaleway', '~> 0.2'
end
