# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_translation_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_translation_manager"
  spec.version       = RailsTranslationManager::VERSION
  spec.authors       = ["Edd Sowden"]
  spec.email         = ["edd.sowden@digital.cabinet-office.gov.uk"]
  spec.summary       = %q{Tasks to manage translation files}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails-i18n"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
