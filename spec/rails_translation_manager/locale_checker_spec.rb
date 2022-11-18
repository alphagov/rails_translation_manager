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

      described_class.new("spec/locales/in_sync/**/*.yml").validate_locales
    end

    it "outputs a confirmation" do
      expect { described_class.new("spec/locales/in_sync/**/*.yml").validate_locales }
        .to output("Locale files are in sync, nice job!\n").to_stdout
    end

    it "returns true" do
      expect(described_class.new("spec/locales/in_sync/**/*.yml").validate_locales)
        .to eq(true)
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

      described_class.new("spec/locales/out_of_sync/*.yml").validate_locales
    end

    it "outputs the report" do
      printed = capture_stdout do
        described_class.new("spec/locales/out_of_sync/*.yml").validate_locales
      end

      expect(printed.scan(/\[ERROR\]/).count).to eq(3)
    end

    it "returns false" do
      expect(described_class.new("spec/locales/out_of_sync/*.yml").validate_locales)
        .to eq(false)
    end
  end

  context "when the locale path doesn't relate to any YAML files" do
    it "doesn't call any checker classes" do
      described_class::CHECKER_CLASSES.each do |checker|
        expect_any_instance_of(checker).to_not receive(:report)
      end

      described_class.new("some/random/path").validate_locales
    end

    it "outputs an error message" do
      expect { described_class.new("some/random/path").validate_locales }
        .to output("No locale files found for the supplied path\n").to_stdout
    end

    it "returns false" do
      expect(described_class.new("some/random/path").validate_locales)
        .to eq(false)
    end
  end
end
