# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'localtunnel/version'

Gem::Specification.new do |spec|
  spec.name          = "localtunnel"
  spec.version       = Localtunnel::VERSION
  spec.authors       = ["DSTIL"]
  spec.email         = ["15gorillas@gmail.com"]
  spec.summary       = %q{Ruby gem wrapping the localtunnel npm package.}
  spec.description   = %q{Ruby gem wrapping the localtunnel npm package.}
  spec.homepage      = "https://github.com/dstil/localtunnel"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]
  spec.post_install_message = "Please ensure that the localtunnel npm package is installed (i.e. `npm install -g localtunnel`)."
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
