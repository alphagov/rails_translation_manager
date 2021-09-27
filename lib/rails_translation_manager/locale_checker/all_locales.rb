# frozen_string_literal: true

class AllLocales
  attr_reader :locale_path

  def initialize(locale_path)
    @locale_path = locale_path
  end

  def generate
    paths = locale_file_paths.compact

    raise NoLocaleFilesFound, "No locale files found for the supplied locale path" if paths.blank?

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
      get_keys_for_locale(locale_file_path: path)
    end
  end

  def get_keys_for_locale(hsh: nil, key_chain: nil, ary: [], locale_file_path: nil)
    hsh ||= YAML.load_file(locale_file_path)
    keys = hsh.keys
    keys.each do |key|
      if hsh.fetch(key).is_a?(Hash)
        get_keys_for_locale(hsh: hsh.fetch(key), key_chain: "#{key_chain}.#{key}", ary: ary)
      else
        keys.each do |final_key|
          ary << "#{key_chain}.#{final_key}"
        end
      end
    end

    # remove locale prefix from keys, e.g: ".en.browse.page" -> "browse.page"
    ary.uniq.map { |key| key.split(".")[2..].join(".") }
  end

  class NoLocaleFilesFound < StandardError; end
end
