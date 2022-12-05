# frozen_string_literal: true

require "rails_translation_manager/version"
require "rails"
require "rails_translation_manager/railtie"
require "rails-i18n"

require "rails_translation_manager/locale_checker/base_checker"
require "rails_translation_manager/locale_checker/locale_checker_helper"
require "rails_translation_manager/locale_checker/missing_declared_locales"
require "rails_translation_manager/locale_checker/missing_foreign_locales"
require "rails_translation_manager/locale_checker/missing_english_locales"
require "rails_translation_manager/locale_checker/plural_forms"
require "rails_translation_manager/locale_checker/incompatible_plurals"
require "rails_translation_manager/locale_checker/undeclared_locale_files"
require "rails_translation_manager/locale_checker/all_locales"
require "rails_translation_manager/locale_checker"
require "rails_translation_manager/cleaner"
require "rails_translation_manager/exporter"
require "rails_translation_manager/importer"

module RailsTranslationManager
  rails_translation_manager = Gem::Specification.find_by_name("rails_translation_manager").gem_dir
  I18n.load_path += ["#{rails_translation_manager}/config/locales/plurals.rb"]

  if ENV["RAILS_TRANSLATION_MANAGER_LOAD_ALL_PLURAL_RULES"]
    rails_i18n_path = Gem::Specification.find_by_name("rails-i18n").gem_dir
    I18n.load_path += Dir["#{rails_i18n_path}/rails/pluralization/*.rb"]
  end

  def self.locale_root
    if ENV["RAILS_TRANSLATION_MANAGER_LOCALE_ROOT"]
      Pathname.new(ENV["RAILS_TRANSLATION_MANAGER_LOCALE_ROOT"])
    else
      Rails.root.join("config/locales")
    end
  end
end
