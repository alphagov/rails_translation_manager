# frozen_string_literal: true

require "spec_helper"

RSpec.describe AllLocales do
  context "when there are locale files" do
    it "generates an array of hashes for all locales" do
      expect(described_class.new("spec/locales/out_of_sync/*.yml").generate)
        .to eq(
          [
            { keys: %w[test wrong_plural wrong_plural.one wrong_plural.zero], locale: :en },
            { keys: %w[other_test], locale: :cy }
          ]
      )
    end
  end

  context "when there aren't any locale files present" do
    it "raises an error" do
      expect { described_class.new("path/to/none/existant/locale/files").generate }
        .to raise_error(AllLocales::NoLocaleFilesFound, 'No locale files found for the supplied path')
    end
  end
  
  context "when some keys are excluded" do
    it "generates an array of hashes without those keys" do
      expect(described_class.new("spec/locales/out_of_sync/*.yml", skip_validation = %w{wrong_plural.one}).generate)
        .to eq(
          [
            { keys: %w[test wrong_plural wrong_plural.zero], locale: :en },
            { keys: %w[other_test], locale: :cy }
          ]
      )
    end
  end

  context "when a key prefix is excluded" do
    it "generates an array of hashes without those keys" do
      expect(described_class.new("spec/locales/out_of_sync/*.yml", skip_validation = %w{wrong_plural}).generate)
        .to eq(
          [
            { keys: %w[test], locale: :en },
            { keys: %w[other_test], locale: :cy }
          ]
      )
    end
  end
end
