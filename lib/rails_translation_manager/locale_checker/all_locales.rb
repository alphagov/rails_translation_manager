# frozen_string_literal: true

class AllLocales
  attr_reader :locale_path

  def initialize(locale_path, skip_validation = [])
    @locale_path = locale_path
    @skip_validation = skip_validation
  end

  def generate
    paths = locale_file_paths.compact

    raise NoLocaleFilesFound, 'No locale files found for the supplied path' if paths.blank?

    paths.flat_map do |locale_group|
      {
        locale: locale_group[:locale],
        keys: all_keys_for_locale(locale_group)
      }
    end
  end

  private

  def locale_file_paths
    I18n.available_locales.map do |locale|
      grouped_paths = Dir[locale_path].select do |path|
        locale = locale.downcase

        path =~ %r{/#{locale}/} || path =~ %r{/#{locale}\.yml$}
      end

      { locale: locale.downcase, paths: grouped_paths } if grouped_paths.present?
    end
  end

  def all_keys_for_locale(locale_group)
    locale_group[:paths].flat_map do |path|
      keys_from_file(file_path: path)
    end
  end

  def keys_from_file(locale_hash: nil, key_chain: nil, locale_keys: [], file_path: nil)
    locale_hash ||= YAML.load_file(file_path)
    keys = locale_hash.keys

    keys.reject! do |key|
      key_chain && @skip_validation.map do |prefix|
        "#{key_chain}.#{key}".start_with? ".#{key_chain.split('.')[1]}.#{prefix}"
      end.any?
    end

    keys.each do |key|
      if locale_hash.fetch(key).is_a?(Hash)
        keys_from_file(locale_hash: locale_hash.fetch(key), key_chain: "#{key_chain}.#{key}", locale_keys:)
      else
        keys.each do |final_key|
          locale_keys << "#{key_chain}.#{final_key}"
        end
      end
    end

    # remove locale prefix from keys, e.g: ".en.browse.page" -> "browse.page"
    locale_keys.uniq.map { |key| key.split('.')[2..].join('.') }
  end

  class NoLocaleFilesFound < StandardError; end
end
