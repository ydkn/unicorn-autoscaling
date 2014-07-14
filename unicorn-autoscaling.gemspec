# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unicorn/auto_scaling/version'

Gem::Specification.new do |spec|
  spec.name          = 'unicorn-autoscaling'
  spec.version       = Unicorn::AutoScaling::VERSION
  spec.authors       = ['Florian Schwab']
  spec.email         = ['me@ydkn.de']
  spec.summary       = %q(Auto-scaling for the Unicorn HTTP server)
  spec.description   = %q(Auto-scaling for the Unicorn HTTP server)
  spec.homepage      = 'https://github.com/ydkn/unicorn-autoscaling'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'unicorn'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
