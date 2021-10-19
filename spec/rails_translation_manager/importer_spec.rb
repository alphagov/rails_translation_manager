require "spec_helper"
require "tmpdir"

RSpec.describe RailsTranslationManager::Importer do
  let(:import_directory) { Dir.mktmpdir }
  let(:yaml_translation_data) { YAML.load_file(import_directory + "/fr.yml")["fr"] }

  before do
    importer = described_class.new(
      locale: :fr,
      csv_path: "spec/locales/importer/fr.csv",
      import_directory: import_directory
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
