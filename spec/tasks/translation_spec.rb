require "spec_helper"
require_relative "../../spec/support/tasks"

describe "rake tasks" do
  before do
    fake_rails = double()
    fake_rails.stub(:root) { Pathname.new("spec") }
    stub_const("Rails", fake_rails)
  end

  describe "translation:import", type: :task do
    let(:task) { Rake::Task["translation:import"] }
    let(:csv_path) { "path/to/import/fr.csv" }
    let!(:importer_instance) { stub_importer }

    it "outputs to stdout" do
      expect { task.execute(csv_path: csv_path) }
        .to output("Imported CSV from: #{csv_path} to #{Rails.root.join("config", "locales")}\n")
        .to_stdout
    end

    it "calls the Importer class with the csv and import paths" do
      task.execute(csv_path: csv_path)

      expect(RailsTranslationManager::Importer)
        .to have_received(:new)
        .with(locale: "fr",
              csv_path: csv_path,
              import_directory: Rails.root.join("config", "locales"))
      expect(importer_instance).to have_received(:import)
    end
  end

  describe "translation:import:all", type: :task do
    let(:task) { Rake::Task["translation:import:all"] }
    let(:csv_directory) { "locales/importer" }
    let!(:importer_instance) { stub_importer }

    it "outputs to stdout" do
      expect { task.execute(csv_directory: csv_directory) }
        .to output("Imported all CSVs from: #{csv_directory} to #{Rails.root.join("config", "locales")}\n")
        .to_stdout
    end

    it "calls the importer class for each target path" do
      task.execute(csv_directory: csv_directory)

      expect(RailsTranslationManager::Importer)
        .to have_received(:new)
        .with(locale: "fr",
              csv_path: "spec/locales/importer/fr.csv",
              import_directory: Rails.root.join("config", "locales"))
      expect(importer_instance).to have_received(:import)
    end
  end

  describe "translation:add_missing", type: :task do
    let(:task) { Rake::Task["translation:add_missing"] }
    let!(:cleaner_instance) { stub_cleaner }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
    end

    it "triggers Cleaner and allows to receive the right arguments" do
      task.execute
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(Rails.root.join("config", "locales"))
      expect(cleaner_instance).to have_received(:clean)
    end

    it "triggers i18n task and allows to receive the right arguments" do
      task.execute(locale: "fr")
      expect(I18n::Tasks::CLI).to have_received(:start).with(
        ["add-missing", "--nil-value", ["-l", "fr"]]
      )
    end
  end

  describe "translation:normalize", type: :task do
    let(:task) { Rake::Task["translation:normalize"] }
    let!(:cleaner_instance) { stub_cleaner }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
    end

    it "triggers Cleaner and allows to receive the right arguments" do
      task.execute(locale_directory: "config/locales")
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(Rails.root.join("config", "locales"))
      expect(cleaner_instance).to have_received(:clean)
    end

    it "triggers i18n task and allows to receive the right arguments" do
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start).with(["normalize"])
    end
  end

  def stub_importer
    importer_instance = instance_double(RailsTranslationManager::Importer)
    allow(RailsTranslationManager::Importer).to receive(:new)
      .and_return(importer_instance)
    allow(importer_instance).to receive(:import)

    importer_instance
  end

  def stub_cleaner
    cleaner_instance = instance_double(RailsTranslationManager::Cleaner)
    allow(RailsTranslationManager::Cleaner)
      .to receive(:new)
      .and_return(cleaner_instance)
    allow(cleaner_instance).to receive(:clean)

    cleaner_instance
  end
end
