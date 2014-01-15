# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linda-socket.io-client/version'

Gem::Specification.new do |spec|
  spec.name          = "linda-socket.io-client"
  spec.version       = Linda::SocketIO::Client::VERSION
  spec.authors       = ["Sho Hashimoto"]
  spec.email         = ["hashimoto@shokai.org"]
  spec.description   = %q{linda-socket.io client for Ruby}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/node-linda/linda-socket.io-client-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "socket.io-client-simple"
end
