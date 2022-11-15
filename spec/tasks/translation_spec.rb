# frozen_string_literal: true

require 'spec_helper'
require_relative '../../spec/support/tasks'

describe 'rake tasks' do
  before do
    allow(RailsTranslationManager)
      .to receive(:locale_root)
      .and_return(Pathname.new('spec/config/locales'))
  end

  describe 'translation:import', type: :task do
    let(:task) { Rake::Task['translation:import'] }
    let(:csv_path) { 'path/to/import/fr.csv' }
    let!(:importer_instance) { stub_importer }

    it 'outputs to stdout' do
      expect { task.execute(csv_path:) }
        .to output("\nImported CSV from: #{csv_path} to #{RailsTranslationManager.locale_root}\n")
        .to_stdout
    end

    it 'calls the Importer class with the csv and import paths' do
      task.execute(csv_path:)

      expect(RailsTranslationManager::Importer)
        .to have_received(:new)
        .with(locale: 'fr',
              csv_path:,
              import_directory: RailsTranslationManager.locale_root,
              multiple_files_per_language: false)
      expect(importer_instance).to have_received(:import)
    end
  end

  describe 'translation:import:all', type: :task do
    let(:task) { Rake::Task['translation:import:all'] }
    let(:csv_directory) { 'spec/locales/importer' }
    let!(:importer_instance) { stub_importer }

    it 'outputs to stdout' do
      expect { task.execute(csv_directory:) }
        .to output("\nImported all CSVs from: #{csv_directory} to #{RailsTranslationManager.locale_root}\n")
        .to_stdout
    end

    it 'calls the importer class for each target path' do
      task.execute(csv_directory:, multiple_files_per_language: true)
      import_paths = Dir['spec/locales/importer/*.csv']

      import_paths.each do |csv_path|
        expect(RailsTranslationManager::Importer)
          .to have_received(:new)
          .with(locale: File.basename(csv_path, '.csv'),
                csv_path:,
                import_directory: RailsTranslationManager.locale_root,
                multiple_files_per_language: true)
      end

      expect(importer_instance).to have_received(:import).exactly(import_paths.count)
    end
  end

  describe 'translation:add_missing', type: :task do
    let(:task) { Rake::Task['translation:add_missing'] }
    let!(:cleaner_instance) { stub_cleaner }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
    end

    it 'triggers Cleaner and allows to receive the right arguments' do
      task.execute
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(RailsTranslationManager.locale_root)
      expect(cleaner_instance).to have_received(:clean)
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      task.execute(locale: 'fr')
      expect(I18n::Tasks::CLI).to have_received(:start).with(
        ['add-missing', '--nil-value', ['-l', 'fr']]
      )
    end
  end

  describe 'translation:normalize', type: :task do
    let(:task) { Rake::Task['translation:normalize'] }
    let!(:cleaner_instance) { stub_cleaner }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
    end

    it 'triggers Cleaner and allows to receive the right arguments' do
      task.execute(locale_directory: 'config/locales')
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(RailsTranslationManager.locale_root)
      expect(cleaner_instance).to have_received(:clean)
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start).with(['normalize'])
    end
  end

  describe 'translation:remove_unused', type: :task do
    let(:task) { Rake::Task['translation:remove_unused'] }
    let!(:cleaner_instance) { stub_cleaner }

    before do
      allow(I18n::Tasks::CLI).to receive(:start)
    end

    it 'triggers Cleaner and allows to receive the right arguments' do
      task.execute(locale_directory: 'config/locales')
      expect(RailsTranslationManager::Cleaner)
        .to have_received(:new)
        .with(RailsTranslationManager.locale_root)
      expect(cleaner_instance).to have_received(:clean)
    end

    it 'triggers i18n task and allows to receive the right arguments' do
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start).with(['remove-unused'])
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
