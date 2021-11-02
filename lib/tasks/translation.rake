require "rails_translation_manager"
require "i18n/tasks/cli"
require_relative "../tasks/translation_helper"

namespace :translation do

  desc "Export a specific locale to CSV."
  task :export, [:directory, :base_locale, :target_locale] => [:environment] do |t, args|
    FileUtils.mkdir_p(args[:directory]) unless File.exist?(args[:directory])
    base_locale = Rails.root.join("config", "locales", args[:base_locale] + ".yml")
    target_locale_path = Rails.root.join("config", "locales", args[:target_locale] + ".yml")
    exporter = RailsTranslationManager::Exporter.new(args[:directory], base_locale, target_locale_path)
    exporter.export
  end

  namespace :export do
    desc "Export all locales to CSV files."
    task :all, [:directory] => [:environment] do |t, args|
      directory = args[:directory] || "tmp/locale_csv"
      FileUtils.mkdir_p(directory) unless File.exist?(directory)
      locales = Dir[Rails.root.join("config", "locales", "*.yml")]
      base_locale = Rails.root.join("config", "locales", "en.yml")
      target_locales = locales - [base_locale.to_s]
      target_locales.each do |target_locale_path|
        exporter = RailsTranslationManager::Exporter.new(directory, base_locale, target_locale_path)
        exporter.export
      end
      puts "Exported locale CSV to #{directory}"
    end
  end

  desc "Import a specific locale CSV to YAML within the app."
  task :import, [:locale, :path] => [:environment] do |t, args|
    importer = RailsTranslationManager::Importer.new(args[:locale], args[:path], Rails.root.join("config", "locales"))
    importer.import
  end

  namespace :import do
    desc "Import all locale CSV files to YAML within the app."
    task :all, [:directory] => [:environment] do |t, args|
      directory = args[:directory] || "tmp/locale_csv"
      Dir[File.join(directory, "*.csv")].each do |csv_path|
        locale = File.basename(csv_path, ".csv")
        importer = RailsTranslationManager::Importer.new(locale, csv_path, Rails.root.join("config", "locales"))
        importer.import
      end
    end
  end

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
