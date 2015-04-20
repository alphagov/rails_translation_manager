require "yaml"
require "i18n"
require_relative "yaml_writer"

class RailsTranslationManager::Stealer
  include YAMLWriter

  # locale is the locale name as a string.
  # source_app_path is the path to the root of the app to steal from.
  # mapping_file_path is the path to a YAML file mapping translation keys in
  # the source app to those in the target app. For example:
  #     document.type: content_item.format
  #     document.published: content_item.metadata.published
  # which will import everything under "document.type" and "document.published" 
  # in the source app, and write it to "content_item.format" and 
  # "content_item.metadata.published" in the target app.
  # locales_path is the path to the locale files to output, which is usually
  # Rails.root.join('config/locales').
  # The process will preserve data already in the output file if it is not
  # referenced in the mapping, but will always override data belonging to keys
  # that are in the mapping.
  def initialize(locale, source_app_path, mapping_file_path, locales_path)
    @locale = locale
    @source_app_path = source_app_path
    @mapping_file_path = mapping_file_path
    @locales_path = locales_path
  end

  def steal_locale
    target_data = convert_locale(get_target_data)
    write_yaml(target_locale_path, target_data)
  end

  def convert_locale(target_data)
    mapping_data.each do |source, target|
      data = source_data[@locale]
      source.split('.').each { |key| data = data.fetch(key, {}) }
      set_recursive(target_data[@locale], target.split("."), data)
    end
    target_data
  end

  private

  def set_recursive(hash, keys, data)
    if keys.empty?
      data
    else
      key = keys.shift
      hash.tap do |h|
        h.merge!({ key => set_recursive(hash.fetch(key, {}), keys, data)})
      end
    end
  end

  def source_locale_path
    File.join(@source_app_path, 'config', 'locales', "#{@locale}.yml")
  end

  def source_data
    @source_data ||= YAML.load_file(source_locale_path)
  end

  def target_locale_path
    File.join(@locales_path, "#{@locale}.yml")
  end

  def default_target_data
    { @locale => {} }
  end

  def get_target_data
    if File.exist?(target_locale_path)
      YAML.load_file(target_locale_path) || default_target_data
    else
      default_target_data
    end
  end

  def mapping_data
    @mapping_data ||= YAML.load_file(@mapping_file_path)
  end

end

