# frozen_string_literal: true

module RailsTranslationManager
  class LocaleChecker
    attr_reader :locale_path

    CHECKER_CLASSES = [MissingEnglishLocales,
                       MissingForeignLocales,
                       IncompatiblePlurals].freeze

    def initialize(locale_path)
      @locale_path = locale_path
    end

    def validate_locales
      if locale_file_paths.compact.blank?
        puts 'No locale files found for the supplied locale path'
        return false
      end

      output_result
    end

    private

    def output_result
      if checker_errors.blank?
        puts 'Locale files are in sync, nice job!'
        true
      else
        checker_errors.each do |error_message|
          puts "\n"
          puts error_message
          puts "\n"
        end
        false
      end
    end

    def checker_errors
      errors = CHECKER_CLASSES.flat_map do |checker|
        checker.new(all_locales).report
      end

      errors.compact
    end

    def all_locales
      @all_locales ||= locale_file_paths.flat_map do |locale_group|
        {
          locale: locale_group[:locale],
          keys: all_keys_for_locale(locale_group)
        }
      end
    end

    def locale_file_paths
      @locale_file_paths ||= I18n.available_locales.map do |locale|
        grouped_paths = Dir[locale_path].select do |path|
          locale = locale.downcase

          # add test case for lookalike
          path =~ %r{/#{locale}/} || path =~ %r{/#{locale}\.yml$}
        end

        { locale: locale.downcase, paths: grouped_paths } if grouped_paths.present?
      end
    end

    def all_keys_for_locale(locale_group)
      locale_group[:paths].flat_map do |path|
        get_keys_for_locale(nil, false, [], locale_group[:locale], path)
      end
    end

    def get_keys_for_locale(hsh = nil, key_chain = nil, ary = [], _locale = nil, locale_file_path = nil)
      hsh ||= YAML.load_file(locale_file_path)
      keys = hsh.keys
      keys.each do |key|
        if hsh.fetch(key).is_a?(Hash)
          get_keys_for_locale(hsh.fetch(key), "#{key_chain}.#{key}", ary)
        else
          keys.each do |final_key|
            ary << "#{key_chain}.#{final_key}"
          end
        end
      end

      # remove locale prefix from keys, e.g: ".en.browse.page" -> "browse.page"
      ary.uniq.map { |key| key.split('.')[2..].join('.') }
    end
  end
end
