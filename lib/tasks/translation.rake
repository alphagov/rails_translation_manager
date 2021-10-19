require "rails_translation_manager"
require "i18n/tasks/cli"
require_relative "../tasks/translation_helper"

namespace :translation do

  desc "Regenerate all locales from the EN locale - run this after adding keys"
  task(:regenerate, [:directory] => [:environment]) do |t, args|
    directory = args[:directory] || "tmp/locale_csv"

    Rake::Task["translation:export:all"].invoke(directory)
    Rake::Task["translation:import:all"].invoke(directory)
  end

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
  task :import, [:csv_path] => [:environment] do |t, args|
    import_dir = Rails.root.join("config", "locales")
    csv_path = args[:csv_path]

    importer = RailsTranslationManager::Importer.new(
      locale: File.basename(args[:csv_path], ".csv"),
      csv_path: csv_path,
      import_directory: Rails.root.join("config", "locales")
    )
    importer.import

    puts "Imported CSV from: #{csv_path} to #{import_dir}"
  end

  namespace :import do
    desc "Import all locale CSV files to YAML within the app."
    task :all, [:csv_directory] => [:environment] do |t, args|
      directory = args[:csv_directory] || "tmp/locale_csv"
      import_dir = Rails.root.join("config", "locales")

      Dir[Rails.root.join(directory, "*.csv")].each do |csv_path|
        importer = RailsTranslationManager::Importer.new(
          locale: File.basename(csv_path, ".csv"),
          csv_path: csv_path,
          import_directory: import_dir,
        )
        importer.import
      end

      puts "Imported all CSVs from: #{directory} to #{import_dir}"
    end
  end

  desc "Check translation files for errors"
  task :validate do
    require 'rails_translation_manager/validator'
    logger = Logger.new(STDOUT)
    validator = RailsTranslationManager::Validator.new(Rails.root.join('config', 'locales'), logger)
    errors = validator.check!
    if errors.any?
      puts "Found #{errors.size} errors:"
      puts errors.map(&:to_s).join("\n")
    else
      puts "Success! No unexpected interpolation keys found."
    end
  end

  desc "Import and convert a locale file from another app."
  task :steal, [:locale, :source_app_path, :mapping_file_path] do |t, args|
    stealer = RailsTranslationManager::Stealer.new(args[:locale], args[:source_app_path], args[:mapping_file_path], Rails.root.join('config', 'locales'))
    stealer.steal_locale
  end

  namespace :steal do
    desc "Import and convert all locale files from another app."
    task :all, [:source_app_path, :mapping_file_path] => [:environment] do |t, args|
      I18n.available_locales.reject { |l| l == :en }.each do |locale|
        stealer = RailsTranslationManager::Stealer.new(locale.to_s, args[:source_app_path], args[:mapping_file_path], Rails.root.join('config', 'locales'))
        stealer.steal_locale
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
