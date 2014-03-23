# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wunder/version'

Gem::Specification.new do |spec|
  spec.name          = "wunder"
  spec.version       = Wunder::VERSION
  spec.authors       = ["Ryan Schultz"]
  spec.email         = ["ryan@ryands.org", "rschultz@grio.com"]
  spec.summary       = %q{CLI tool for getting current weather conditions in your terminal}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/ryands/wunder-rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency 'thor'     # cli magic
  spec.add_dependency 'httparty' # http calls
  spec.add_dependency 'hashie'   # Hash extensions for lazy 'models'

  # Json Parser
  spec.add_dependency 'multi_json'
  
end
