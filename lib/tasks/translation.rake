# frozen_string_literal: true

require 'i18n/tasks/cli'
require_relative '../rails_translation_manager'
require_relative '../rails_translation_manager/i18n_tasks_option_parser'

namespace :translation do
  desc 'Export a specific locale to CSV.'
  task :export, %i[directory base_locale target_locale] => [:environment] do |_t, args|
    locale_root = RailsTranslationManager.locale_root
    FileUtils.mkdir_p(args[:directory]) unless File.exist?(args[:directory])
    base_locale = locale_root.join("#{args[:base_locale]}.yml")
    target_locale_path = locale_root.join("#{args[:target_locale]}.yml")
    exporter = RailsTranslationManager::Exporter.new(args[:directory], base_locale, target_locale_path)
    exporter.export
  end

  namespace :export do
    desc 'Export all locales to CSV files.'
    task :all, [:directory] => [:environment] do |_t, args|
      locale_root = RailsTranslationManager.locale_root
      directory = args[:directory] || 'tmp/locale_csv'
      FileUtils.mkdir_p(directory) unless File.exist?(directory)
      locales = Dir[locale_root.join('*.yml')]
      base_locale = locale_root.join('en.yml')
      target_locales = locales - [base_locale.to_s]
      target_locales.each do |target_locale_path|
        exporter = RailsTranslationManager::Exporter.new(directory, base_locale, target_locale_path)
        exporter.export
      end
      puts "Exported locale CSV to #{directory}"
    end
  end

  desc 'Import a specific locale CSV to YAML within the app.'
  task :import, %i[csv_path multiple_files_per_language] => [:environment] do |_t, args|
    csv_path = args[:csv_path]

    importer = RailsTranslationManager::Importer.new(
      locale: File.basename(args[:csv_path], '.csv'),
      csv_path:,
      import_directory: RailsTranslationManager.locale_root,
      multiple_files_per_language: args[:multiple_files_per_language] || false
    )
    importer.import

    puts "\nImported CSV from: #{csv_path} to #{RailsTranslationManager.locale_root}"
  end

  namespace :import do
    desc 'Import all locale CSV files to YAML within the app.'
    task :all, %i[csv_directory multiple_files_per_language] => [:environment] do |_t, args|
      directory = args[:csv_directory] || 'tmp/locale_csv'

      Dir["#{directory}/*.csv"].each do |csv_path|
        importer = RailsTranslationManager::Importer.new(
          locale: File.basename(csv_path, '.csv'),
          csv_path:,
          import_directory: RailsTranslationManager.locale_root,
          multiple_files_per_language: args[:multiple_files_per_language] || false
        )
        importer.import
      end

      puts "\nImported all CSVs from: #{directory} to #{RailsTranslationManager.locale_root}"
    end
  end

  desc 'Add missing translations'
  task(:add_missing, [:locale] => [:environment]) do |_t, args|
    option_parser = RailsTranslationManager::I18nTasksOptionParser.new(
      ['add-missing', '--nil-value'], args[:locale]
    ).with_optional_locale

    I18n::Tasks::CLI.start(option_parser)
    RailsTranslationManager::Cleaner.new(RailsTranslationManager.locale_root).clean
  end

  desc 'Normalize translations'
  task(:normalize, [:locale] => [:environment]) do |_t, args|
    option_parser = RailsTranslationManager::I18nTasksOptionParser.new(
      ['normalize'], args[:locale]
    ).with_optional_locale

    I18n::Tasks::CLI.start(option_parser)
    RailsTranslationManager::Cleaner.new(RailsTranslationManager.locale_root).clean
  end

  desc 'Remove unused keys'
  task(:remove_unused, [:locale] => [:environment]) do |_t, args|
    option_parser = RailsTranslationManager::I18nTasksOptionParser.new(
      ['remove-unused'], args[:locale]
    ).with_optional_locale

    I18n::Tasks::CLI.start(option_parser)
    RailsTranslationManager::Cleaner.new(RailsTranslationManager.locale_root).clean
  end
end
