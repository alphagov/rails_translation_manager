# frozen_string_literal: true

require 'rails_translation_manager'

module RailsTranslationManager
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.expand_path('../tasks/*.rake', File.dirname(__FILE__))].each { |f| load f }
    end
  end
end
