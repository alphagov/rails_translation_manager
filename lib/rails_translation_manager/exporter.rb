# frozen_string_literal: true

require 'yaml'
require 'csv'
require 'i18n'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'

module RailsTranslationManager
  class Exporter
    def initialize(directory, source_locale_path, target_locale_path)
      @source_locale_path = source_locale_path
      @target_locale_path = target_locale_path
      @source_locale = File.basename(target_locale_path).split('.')[0]
      @target_locale = File.basename(target_locale_path).split('.')[0]
      @output_path = File.join(directory, "#{@target_locale}.csv")

      @keyed_source_data = translation_file_to_keyed_data(source_locale_path, @source_locale)
      @keyed_target_data = translation_file_to_keyed_data(target_locale_path, @target_locale)
    end

    def export
      csv = CSV.generate do |csv|
        csv << CSV::Row.new(%w[key source translation], %w[key source translation], true)
        @keyed_source_data.keys.sort.each do |key|
          next if key =~ (/^language_names\./) && key !~ /#{@target_locale}$/

          if is_pluralized_key?(key)
            export_pluralization_rows(key, csv)
          else
            csv << export_row(key, @keyed_source_data[key], @keyed_target_data[key])
          end
        end
      end
      File.open(@output_path, 'w') { |f| f.write csv.to_s }
    end

    private

    def export_pluralization_rows(key, csv)
      I18n.t('i18n.plural.keys', locale: @target_locale).map(&:to_s).each do |plural_key|
        csv << export_row(depluralized_key_for(key, plural_key), @keyed_source_data.fetch(key, {})[plural_key],
                          @keyed_target_data.fetch(key, {})[plural_key])
      end
    end

    def export_row(key, source_value, target_value)
      CSV::Row.new(%w[key source translation], [key, source_value, target_value])
    end

    def translation_file_to_keyed_data(path, locale)
      if File.exist?(path)
        hash = YAML.load_file(path).values[0]
        hash_to_keyed_data('', hash, locale)
      else
        {}
      end
    end

    def hash_to_keyed_data(prefix, hash, locale)
      if hash_is_for_pluralization?(hash, locale)
        { pluralized_prefix(prefix) => hash.stringify_keys }
      else
        results = {}
        hash.each do |key, value|
          if value.is_a?(Hash)
            results.merge!(hash_to_keyed_data(key_for(prefix, key), value, locale))
          else
            results[key_for(prefix, key)] = value
          end
        end
        results
      end
    end

    # if the hash is only made up of the plural keys for the locale, we
    # assume it's a plualization set.  Note that zero is *always* an option
    # regardless of the keys fetched
    # (see https://github.com/svenfuchs/i18n/blob/master/lib/i18n/backend/pluralization.rb#L34)
    def hash_is_for_pluralization?(hash, locale)
      plural_keys = I18n.t('i18n.plural.keys', locale:)
      raise missing_pluralisations_message(locale) unless plural_keys.is_a?(Array)

      ((hash.keys.map(&:to_s) - plural_keys.map(&:to_s)) - ['zero']).empty?
    end

    def missing_pluralisations_message(locale)
      "No pluralization forms defined for locale '#{locale}'. " \
        'This probably means that the rails-18n gem does not provide a ' \
        'definition of the plural forms for this locale, you may need to ' \
        'define them yourself.'
    end

    def key_for(prefix, key)
      prefix.blank? ? key.to_s : "#{prefix}.#{key}"
    end

    def is_pluralized_key?(key)
      key =~ /\APLURALIZATION-KEY:/
    end

    def pluralized_prefix(prefix)
      if is_pluralized_key?(prefix)
        prefix
      else
        "PLURALIZATION-KEY:#{prefix}"
      end
    end

    def depluralized_key_for(prefix, key)
      depluralized_prefix = prefix.gsub(/\APLURALIZATION-KEY:/, '')
      key_for(depluralized_prefix, key)
    end
  end
end
