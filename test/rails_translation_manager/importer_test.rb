require "test_helper"
require "rails_translation_manager/importer"
require "tmpdir"
require "csv"

module RailsTranslationManager
  class ImporterTest < Minitest::Test
    test 'should create a new locale file for a filled in translation csv file' do
      given_csv(:fr,
        [:key, :source, :translation],
        ["world_location.type.country", "Country", "Pays"],
        ["world_location.country", "Germany", "Allemange"],
        ["other.nested.key", "original", "translated"]
      )

      Importer.new(:fr, csv_path(:fr), import_directory).import

      yaml_translation_data = YAML.load_file(File.join(import_directory, "fr.yml"))
      expected = {"fr" => {
        "world_location" => {
          "country" => "Allemange",
          "type" => {
            "country" => "Pays"
          }
        },
        "other" => {
          "nested" => {
            "key" => "translated"
          }
        }
      }}
      assert_equal expected, yaml_translation_data
    end

    test 'imports arrays from CSV as arrays' do
      given_csv(:fr,
        [:key, :source, :translation],
        ["fruit", ["Apples", "Bananas", "Pears"], ["Pommes", "Bananes", "Poires"]]
      )

      Importer.new(:fr, csv_path(:fr), import_directory).import

      yaml_translation_data = YAML.load_file(File.join(import_directory, "fr.yml"))
      expected = {"fr" => {
        "fruit" => ["Pommes", "Bananes", "Poires"]
      }}
      assert_equal expected, yaml_translation_data
    end

    test 'interprets string "nil" as nil' do
      given_csv(:fr,
        [:key, :source, :translation],
        ["things", ["one", nil, "two"], ["une", nil, "deux"]]
      )

      Importer.new(:fr, csv_path(:fr), import_directory).import

      yaml_translation_data = YAML.load_file(File.join(import_directory, "fr.yml"))
      expected = {"fr" => {
        "things" => ["une", nil, "deux"]
      }}
      assert_equal expected, yaml_translation_data
    end

    test 'interprets string ":thing" as symbol' do
      given_csv(:fr,
        [:key, :source, :translation],
        ["sentiment", ":whatever", ":bof"]
      )

      Importer.new(:fr, csv_path(:fr), import_directory).import

      yaml_translation_data = YAML.load_file(File.join(import_directory, "fr.yml"))
      expected = {"fr" => {
        "sentiment" => :bof
      }}
      assert_equal expected, yaml_translation_data
    end

    test 'interprets integer strings as integers' do
      given_csv(:fr,
        [:key, :source, :translation],
        ["price", "123", "123"]
      )

      Importer.new(:fr, csv_path(:fr), import_directory).import

      yaml_translation_data = YAML.load_file(File.join(import_directory, "fr.yml"))
      expected = {"fr" => {
        "price" => 123
      }}
      assert_equal expected, yaml_translation_data
    end

    test 'interprets boolean values as booleans, not strings' do
      given_csv(:fr,
        [:key, :source, :translation],
        ["key1", "is true", "true"],
        ["key2", "is false", "false"]
      )

      Importer.new(:fr, csv_path(:fr), import_directory).import

      yaml_translation_data = YAML.load_file(File.join(import_directory, "fr.yml"))
      expected = {"fr" => {
        "key1" => true,
        "key2" => false
      }}
      assert_equal expected, yaml_translation_data
    end

  private

    def csv_path(locale)
      File.join(import_directory, "#{locale}.csv")
    end

    def given_csv(locale, header_row, *rows)
      csv = CSV.generate do |csv|
        csv << CSV::Row.new(["key", "source", "translation"], ["key", "source", "translation"], true)
        rows.each do |row|
          csv << CSV::Row.new(["key", "source", "translation"], row)
        end
      end
      File.open(csv_path(locale), "w") { |f| f.write csv.to_s }
    end

    def import_directory
      @import_directory ||= Dir.mktmpdir
    end
  end
end
