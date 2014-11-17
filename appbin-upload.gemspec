# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appbin/upload/version'

Gem::Specification.new do |spec|
  spec.name          = "appbin-upload"
  spec.version       = Appbin::Upload::VERSION
  spec.authors       = ["takashi nagayasu"]
  spec.email         = ["regist@g-onion.org"]
  spec.summary       = %q{Smartphone application binary uploader.}
  spec.description   = %q{Smartphone application binary uploader.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
