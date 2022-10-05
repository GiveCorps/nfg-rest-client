# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nfg-rest-client/version'

Gem::Specification.new do |spec|
  spec.name          = "nfg-rest-client"
  spec.version       = NfgRestClient::VERSION
  spec.authors       = ["Thomas Hoen"]
  spec.email         = ["tom.hoen@networkforgood.com"]

  spec.summary       = %q{ The nfg-rest-client is a ruby wrapper for NetworkforGood's restful api}
  spec.description   = %q{ The nfg-rest-client is a ruby wrapper for NetworkforGood's restful api}
  spec.homepage      = "https://github.com/network-for-good/nfg-rest-client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.pkg.github.com/network-for-good"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.33"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "byebug"


  spec.add_dependency "activesupport"
  spec.add_dependency "json"
  spec.add_dependency "flexirest"
end
