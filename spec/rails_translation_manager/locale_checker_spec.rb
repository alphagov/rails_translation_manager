# frozen_string_literal: true

require "spec_helper"

RSpec.describe RailsTranslationManager::LocaleChecker do
  context "when the locales are valid" do
    before do
      I18n.backend.load_translations(
        ["spec/locales/in_sync/cy/browse.yml", "spec/locales/in_sync/en/browse.yml"]
      )
    end

    it "calls each checker class" do
      described_class::CHECKER_CLASSES.each do |checker|
        expect_any_instance_of(checker).to receive(:report)
      end

      expect { described_class.new("spec/locales/in_sync/**/*.yml").validate_locales }
        .to output.to_stdout
    end

    it "outputs a confirmation" do
      expect { described_class.new("spec/locales/in_sync/**/*.yml").validate_locales }
        .to output("Locale files are in sync, nice job!\n").to_stdout
    end

    it "returns true" do
      outcome = nil
      expect { outcome = described_class.new("spec/locales/in_sync/**/*.yml").validate_locales }.to output.to_stdout
      expect(outcome).to be(true)
    end
  end

  context "when the locales are not valid" do
    before do
      I18n.backend.load_translations(
        ["spec/locales/out_of_sync/cy.yml", "spec/locales/out_of_sync/en.yml"]
      )
    end

    it "calls each checker class" do
      described_class::CHECKER_CLASSES.each do |checker|
        expect_any_instance_of(checker).to receive(:report)
      end

      expect { described_class.new("spec/locales/out_of_sync/*.yml").validate_locales }
        .to output.to_stdout
    end

    it "outputs the report" do
      # expect output to contain 3 errors ([ERROR])
      expect { described_class.new("spec/locales/out_of_sync/*.yml").validate_locales }
        .to output(/(?:\[ERROR\](?:.|\n)*){3}/).to_stdout
    end

    it "returns false" do
      outcome = nil
      expect { outcome = described_class.new("spec/locales/out_of_sync/*.yml").validate_locales }.to output.to_stdout
      expect(outcome).to be(false)
    end
  end

  context "when the locale path doesn't relate to any YAML files" do
    it "outputs an error message" do
      expect { described_class.new("some/random/path").validate_locales }
        .to output("No locale files found for the supplied path\n").to_stdout
    end

    it "returns false" do
      outcome = nil
      expect { outcome = described_class.new("some/random/path").validate_locales }.to output.to_stdout
      expect(outcome).to be(false)
    end
  end
end
