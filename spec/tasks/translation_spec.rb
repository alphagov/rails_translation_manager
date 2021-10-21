require 'spec_helper'
require_relative '../../spec/support/tasks'

describe 'rake tasks' do
  before do
    fake_rails = double()
    fake_rails.stub(:root) { Pathname.new('spec') }
    stub_const("Rails", fake_rails)
  end

  describe 'translation:import', type: :task do
    let(:importer_instance) { instance_double(RailsTranslationManager::Importer) }

    before do
      allow(RailsTranslationManager::Importer).to receive(:new)
        .and_return(importer_instance)
      allow(importer_instance).to receive(:import)
    end

    context 'when importing a single locale' do
      let(:task) { Rake::Task["translation:import"] }
      let(:csv_path) { "path/to/import/fr.csv" }

      it 'outputs to stdout' do
        expect { task.execute(csv_path: csv_path) }
          .to output("Imported CSV from: #{csv_path} to #{Rails.root.join("config", "locales")}\n")
          .to_stdout
      end

      it 'calls the Importer class with the csv and import paths' do
        task.execute(csv_path: "path/to/import/fr.csv")

        expect(RailsTranslationManager::Importer)
          .to have_received(:new)
          .with(locale: "fr",
                csv_path: csv_path,
                import_directory: Rails.root.join("config", "locales"))
        expect(importer_instance).to have_received(:import)
      end
    end

    context 'when importing all locales' do
      let(:task) { Rake::Task["translation:import:all"] }
      let(:csv_directory) { "spec/locales/importer" }

      it 'outputs to stdout' do
        expect { task.execute(csv_directory: csv_directory) }
          .to output("Imported all CSVs from: #{csv_directory} to #{Rails.root.join("config", "locales")}\n")
          .to_stdout
      end

      it 'calls the importer class for each target path' do
        task.execute(csv_directory: csv_directory)

        expect(RailsTranslationManager::Importer)
          .to have_received(:new)
          .with(locale: "fr",
                csv_path: "spec/locales/importer/fr.csv",
                import_directory: Rails.root.join("config", "locales"))
        expect(importer_instance).to have_received(:import)
      end
    end
  end

  describe 'translation:add_missing', type: :task do
    let(:task) { Rake::Task["translation:add_missing"] }
    let(:cleaner_instance) { instance_double(RailsTranslationManager::Cleaner) }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
      allow(RailsTranslationManager::Cleaner)
        .to receive(:new)
        .and_return(cleaner_instance)
      allow(cleaner_instance).to receive(:clean)
    end

    it 'triggers Cleaner and allows to receive the right arguments' do
      task.execute
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(Rails.root.join("config", "locales"))
      expect(cleaner_instance).to have_received(:clean)
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      task.execute(locale: "fr")
      expect(I18n::Tasks::CLI).to have_received(:start).with(
        ["add-missing", "--nil-value", ["-l", "fr"]]
      )
    end
  end

  describe 'translation:normalize', type: :task do
    let(:task) { Rake::Task["translation:normalize"] }
    let(:cleaner_instance) { instance_double(RailsTranslationManager::Cleaner) }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
      allow(RailsTranslationManager::Cleaner)
        .to receive(:new)
        .and_return(cleaner_instance)
      allow(cleaner_instance).to receive(:clean)
    end

    it 'triggers Cleaner and allows to receive the right arguments' do
      task.execute(locale_directory: "config/locales")
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(Rails.root.join("config", "locales"))
      expect(cleaner_instance).to have_received(:clean)
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start).with(["normalize"])
    end
  end
end
