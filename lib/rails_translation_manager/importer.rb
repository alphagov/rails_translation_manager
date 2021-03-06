require "yaml"
require "csv"
require_relative "yaml_writer"

class RailsTranslationManager::Importer
  include YAMLWriter

  def initialize(locale, csv_path, import_directory)
    @csv_path = csv_path
    @locale = locale
    @import_directory = import_directory
  end

  def import
    csv = CSV.read(@csv_path, headers: true, header_converters: :downcase)
    data = {}
    csv.each do |row|
      key = row["key"]
      key_parts = key.split(".")
      if key_parts.length > 1
        leaf_node = (data[key_parts.first] ||= {})
        key_parts[1..-2].each do |part|
          leaf_node = (leaf_node[part] ||= {})
        end
        leaf_node[key_parts.last] = parse_translation(row["translation"])
      else
        data[key_parts.first] = parse_translation(row["translation"])
      end
    end

    write_yaml(import_yml_path, {@locale.to_s => data})
  end

  private

  def import_yml_path
    File.join(@import_directory, "#{@locale}.yml")
  end

  def parse_translation(translation)
    if translation =~ /^\[/
      values = translation.gsub(/^\[/, '').gsub(/\]$/, '').gsub("\"", '').split(/\s*,\s*/)
      values.map { |v| parse_translation(v) }
    elsif translation =~ /^:/
      translation.gsub(/^:/, '').to_sym
    elsif translation =~ /^true$/
      true
    elsif translation =~ /^false$/
      false
    elsif translation =~ /^\d+$/
      translation.to_i
    elsif translation == "nil"
      nil
    else
      translation
    end
  end
end
