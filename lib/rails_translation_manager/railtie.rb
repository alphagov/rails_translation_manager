require 'rails_translation_manager'

module RailsTranslationManager
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.expand_path('../tasks/*.rake', File.dirname(__FILE__))].each { |f| load f }
    end

    config.after_initialize do
      if ENV["RAILS_TRANSLATION_MANAGER_LOAD_ALL_PLURAL_RULES"]
        rails_i18n_path = Gem::Specification.find_by_name("rails-i18n").gem_dir
        I18n.load_path += Dir["#{rails_i18n_path}/rails/pluralization/*.rb"]
      end

      rails_translation_manager = Gem::Specification.find_by_name("rails_translation_manager").gem_dir
      I18n.load_path += ["#{rails_translation_manager}/config/locales/plurals.rb"]
    end
  end
end
