require "spec_helper"
require "tmpdir"

RSpec.describe RailsTranslationManager::Importer do
  let(:import_directory) { Dir.mktmpdir }

  it "imports CSV containing a byte order mark" do
    importer = described_class.new(
      locale: "hy",
      csv_path: "spec/locales/importer/hy_with_byte_order_mark.csv",
      import_directory: import_directory,
      multiple_files_per_language: false
    )
    importer.import

    expect(File).to exist(import_directory + "/hy.yml")
  end

  it "doesn't try to import a row with a blank key" do
    importer = described_class.new(
      locale: "hy",
      csv_path: "spec/locales/importer/fr.csv",
      import_directory: import_directory,
      multiple_files_per_language: false
    )

    expect { importer.import }.to output(
      "Invalid row: #<CSV::Row \"key\":nil \"source\":nil \"translation\":nil> for csv_path: spec/locales/importer/fr.csv\n"
    ).to_stdout
  end

  context "when there is one locale file per language" do
    let(:yaml_translation_data) { YAML.load_file(import_directory + "/fr.yml")["fr"] }

    before do
      importer = described_class.new(
        locale: "fr",
        csv_path: "spec/locales/importer/fr.csv",
        import_directory: import_directory,
        multiple_files_per_language: false
      )
      importer.import
    end

    it "creates one YAML file per language" do
      expect(File).to exist(import_directory + "/fr.yml")
    end

    it "imports nested locales" do
      expected = { "type" => { "country" => "Pays" } }
      expect(yaml_translation_data).to include("world_location" => hash_including(expected))
    end

    it "imports arrays from CSV as arrays" do
      expected =  { "fruit" => ["Pommes", "Bananes", "Poires"] }
      expect(yaml_translation_data).to include("world_location" => hash_including(expected))
    end

    it "imports string 'nil' as nil" do
      expected = { "things" => nil }
      expect(yaml_translation_data).to include("world_location" => hash_including(expected))
    end

    it "imports string ':thing' as symbol" do
      expected = { "sentiment" => :bof }
      expect(yaml_translation_data).to include("world_location" => hash_including(expected))
    end

    it "imports integer strings as integers" do
      expected = { "price" => 123 }
      expect(yaml_translation_data).to include("shared" => hash_including(expected))
    end

    it "imports boolean values as booleans, not strings" do
      expected = { "key1" => true, "key2" => false }
      expect(yaml_translation_data).to include("shared" => hash_including(expected))
    end
  end

  context "when there are multiple files per locale" do
    before do
      importer = described_class.new(
        locale: "fr",
        csv_path: "spec/locales/importer/fr.csv",
        import_directory: import_directory,
        multiple_files_per_language: true
      )
      importer.import
    end

    it "creates multiple YAML files per language in the language's directory" do
      expect(File).to exist(import_directory + "/fr/world_location.yml")
                  .and exist(import_directory + "/fr/shared.yml")
    end

    it "imports only 'world_location' locales to the relevant file" do
      yaml_translation_data = YAML.load_file(import_directory + "/fr/world_location.yml")["fr"]
      expect(yaml_translation_data).to match("world_location" => anything)
    end

    it "imports only 'shared' locales to the relevant file" do
      yaml_translation_data = YAML.load_file(import_directory + "/fr/shared.yml")["fr"]
      expect(yaml_translation_data).to match("shared" => anything)
    end
  end
end
