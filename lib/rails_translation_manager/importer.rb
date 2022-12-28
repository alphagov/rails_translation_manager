require "yaml"
require "csv"
require_relative "yaml_writer"

class RailsTranslationManager::Importer
  include YAMLWriter

  attr_reader :locale, :csv_path, :import_directory, :multiple_files_per_language

  def initialize(locale:, csv_path:, import_directory:, multiple_files_per_language:)
    @locale = locale
    @csv_path = csv_path
    @import_directory = import_directory
    @multiple_files_per_language = multiple_files_per_language
  end

  def import
    csv = reject_nil_keys(
      CSV.read(csv_path, encoding: "bom|utf-8", headers: true, header_converters: :downcase)
    )

    multiple_files_per_language ? import_csv_into_multiple_files(csv) : import_csv(csv)
  end

  private

  def import_csv(csv, import_yml_path = File.join(import_directory, "#{locale}.yml"))
    data = csv.each_with_object({}) do |row, hash|
      key = row["key"]
      key_parts = key.split(".")
      if key_parts.length > 1
        leaf_node = (hash[key_parts.first] ||= {})
        key_parts[1..-2].each do |part|
          leaf_node = (leaf_node[part] ||= {})
        end
        leaf_node[key_parts.last] = parse_translation(row["translation"])
      else
        hash[key_parts.first] = parse_translation(row["translation"])
      end
    end

    write_yaml(import_yml_path, { locale.to_s => data })
  end

  def reject_nil_keys(csv)
    csv.reject do |row|
      nil_key = row["key"].nil?
      puts "Invalid row: #{row.inspect} for csv_path: #{csv_path}\n" if nil_key == true
      nil_key
    end
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

  def import_csv_into_multiple_files(csv)
    group_csv_by_file(csv).each do |group|
      language_dir =  File.join(import_directory, locale)

      Dir.mkdir(language_dir) unless Dir.exist?(language_dir)

      import_yml_path = File.join(import_directory, locale, "#{group[0]}.yml")
      import_csv(group[1], import_yml_path)
    end
  end

  def group_csv_by_file(csv)
    csv.group_by { |row| row["key"].split(".").first }
  end
end
