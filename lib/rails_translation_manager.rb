# frozen_string_literal: true

require "rails_translation_manager/version"
require "rails_translation_manager/railtie" if defined?(Rails)
require "rails-i18n"

require 'rails_translation_manager/locale_checker/base_checker'
require 'rails_translation_manager/locale_checker/locale_checker_helper'
require 'rails_translation_manager/locale_checker/missing_foreign_locales'
require 'rails_translation_manager/locale_checker/missing_english_locales'
require 'rails_translation_manager/locale_checker/plural_forms'

module RailsTranslationManager
  autoload :Exporter, "rails_translation_manager/exporter"
  autoload :Importer, "rails_translation_manager/importer"
  autoload :Stealer, "rails_translation_manager/stealer"

  rails_i18n_path = Gem::Specification.find_by_name("rails-i18n").gem_dir
  rails_translation_manager = Gem::Specification.find_by_name("rails_translation_manager").gem_dir

  I18n.load_path.concat(
    Dir["#{rails_i18n_path}/rails/pluralization/*.rb"],
    ["#{rails_translation_manager}/config/locales/plurals.rb"]
  )
end
