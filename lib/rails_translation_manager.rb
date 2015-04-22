require "rails_translation_manager/version"
require "rails_translation_manager/railtie" if defined?(Rails)
require "rails-i18n"

module RailsTranslationManager
  autoload :Exporter, "rails_translation_manager/exporter"
  autoload :Importer, "rails_translation_manager/importer"
  autoload :Stealer, "rails_translation_manager/stealer"
end
