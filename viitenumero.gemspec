# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viitenumero/version'

Gem::Specification.new do |spec|
  spec.name          = "viitenumero"
  spec.version       = Viitenumero::VERSION
  spec.authors       = ["Alexander Hanhikoski"]
  spec.email         = ["tech@pikasiirto.fi"]

  spec.summary       = %q{Generates and validates Finnish national reference numbers (viitenumero).}
  spec.homepage      = "https://github.com/bittisiirto/viitenumero"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "activemodel", ">= 4.0.0"
  spec.add_runtime_dependency "activesupport", ">= 4.0.0"
end
