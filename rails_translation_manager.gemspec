# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_translation_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_translation_manager"
  spec.version       = RailsTranslationManager::VERSION
  spec.authors       = ["GOV.UK Dev"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]
  spec.summary       = %q{Tasks to manage translation files}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.3"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "csv", "~> 3.2"
  spec.add_dependency "i18n-tasks"
  spec.add_dependency "rails-i18n"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
