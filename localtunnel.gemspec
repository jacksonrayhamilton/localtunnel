# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'localtunnel/version'

Gem::Specification.new do |spec|
  spec.name          = "localtunnel"
  spec.version       = Localtunnel::VERSION
  spec.authors       = ["Swinburne Software Innovation Lab"]
  spec.email         = ["god@ssil.com.au"]
  spec.summary       = %q{Ruby gem for localtunnel.}
  spec.description   = %q{Ruby gem for localtunnel.}
  spec.homepage      = "https://github.com/ssilab/localtunnel"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
