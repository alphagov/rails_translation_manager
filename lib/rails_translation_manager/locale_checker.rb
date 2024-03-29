# frozen_string_literal: true

module RailsTranslationManager
  class LocaleChecker
    attr_reader :locale_path

    CHECKER_CLASSES = [IncompatiblePlurals,
                       MissingDeclaredLocales,
                       MissingEnglishLocales,
                       MissingForeignLocales,
                       UndeclaredLocaleFiles].freeze

    def initialize(locale_path, skip_validation = [])
      @locale_path = locale_path
      @skip_validation = skip_validation
    end

    def validate_locales
      output_result
    rescue AllLocales::NoLocaleFilesFound => e
      puts e
      false
    end

  private

    def output_result
      errors = checker_errors.compact

      if errors.blank?
        puts "Locale files are in sync, nice job!"
        true
      else
        errors.each do |error_message|
          puts "\n"
          puts error_message
          puts "\n"
        end
        false
      end
    end

    def checker_errors
      CHECKER_CLASSES.flat_map do |checker|
        checker.new(all_locales).report
      end
    end

    def all_locales
      @all_locales ||= AllLocales.new(locale_path, @skip_validation).generate
    end
  end
end
