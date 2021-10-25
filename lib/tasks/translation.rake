require "rails_translation_manager"
require "i18n/tasks/cli"
require_relative "../tasks/translation_helper"

namespace :translation do

  desc "Add missing translations"
  task(:add_missing, [:locale] => [:environment]) do |t, args|
    I18n::Tasks::CLI.start(TranslationHelper.new(["add-missing", "--nil-value"], args[:locale]).with_optional_locale)
    RailsTranslationManager::Cleaner.new(Rails.root.join("config", "locales")).clean
  end

  desc "Normalize translations"
  task(:normalize, [:locale] => [:environment]) do |t, args|
    I18n::Tasks::CLI.start(TranslationHelper.new(["normalize"], args[:locale]).with_optional_locale)
    RailsTranslationManager::Cleaner.new(Rails.root.join("config", "locales")).clean
  end
end
