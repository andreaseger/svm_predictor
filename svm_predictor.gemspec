# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svm_predictor/version'

Gem::Specification.new do |spec|
  spec.name          = "svm_predictor"
  spec.version       = SvmPredictor::VERSION
  spec.authors       = ["Andreas Eger"]
  spec.email         = ["dev@eger-andreas.de"]
  spec.description   = %q{shared predictor model and api helper}
  spec.summary       = %q{helper model to save and load libsvm models generated via svm_helper and svm_trainer}
  spec.homepage      = "https://github.com/sch1zo/svm_predictor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "svm_helper"
  # spec.add_dependency "rb-libsvm", "~> 1.1.2"
  spec.add_dependency "active_support"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
