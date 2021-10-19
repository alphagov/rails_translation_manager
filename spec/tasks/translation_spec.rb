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

      it 'outputs to stdout' do
        expect {
          task.execute(csv_path: "path/to/import/fr.csv", import_directory: "config/locales")
        }.to output.to_stdout
      end

      it 'calls the Importer class with the csv and import paths' do
        task.execute(csv_path: "path/to/import/fr.csv", import_directory: "config/locales")

        expect(RailsTranslationManager::Importer).to have_received(:new)
          .with(locale: "fr", csv_path: "path/to/import/fr.csv", import_directory: "config/locales")
        expect(importer_instance).to have_received(:import)
      end
    end

    context 'when importing all locales' do
      let(:task) { Rake::Task["translation:import:all"] }

      it 'outputs to stdout' do
        expect { task.execute(
          csv_directory: "spec/locales/importer", import_directory: "config/locales")
        }.to output.to_stdout
      end

      it 'calls the importer class for each target path' do
        task.execute(csv_directory: "spec/locales/importer", import_directory: "config/locales")

        expect(RailsTranslationManager::Importer).to have_received(:new)
          .with(locale: "fr", csv_path: "spec/locales/importer/fr.csv", import_directory: "config/locales")
        expect(importer_instance).to have_received(:import)
      end
    end
  end

  describe 'translation:add_missing', type: :task do
    let(:task) { Rake::Task["translation:add_missing"] }

    it 'is executed' do
      expect { task.execute }.to output.to_stdout
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      allow(I18n::Tasks::CLI).to receive(:start)
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start).with(["add-missing", "--nil-value"])
    end
  end

  describe 'translation:normalize', type: :task do
    let(:task) { Rake::Task["translation:normalize"] }

    it 'is executed' do
      expect { task.execute }.to_not output.to_stdout
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      allow(I18n::Tasks::CLI).to receive(:start)
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start).with(["normalize"])
    end
  end
end
