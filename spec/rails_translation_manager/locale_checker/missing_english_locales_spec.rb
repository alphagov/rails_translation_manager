# frozen_string_literal: true

require "spec_helper"

RSpec.describe MissingEnglishLocales do
  context "where there are missing English locales" do
    before do
      I18n.backend.store_translations :en, { browse: { same_key: "value" } }
      I18n.backend.store_translations :cy, { browse: { same_key: "value" } }
      I18n.backend.store_translations :cy, { browse: { extra_key: "extra_key" } }
    end

    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.same_key]
        },
        {
          locale: :cy,
          keys: %w[browse.same_key browse.extra_key]
        }
      ]
    end

    it "outputs the missing locales" do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m Missing English locales, either remove these keys from the foreign locales or add them to the English locales

            \e[1mMissing English keys:\e[22m ["browse.extra_key"]
            \e[1mFound in:\e[22m [:cy]
          OUTPUT
        )
    end
  end

  context "where there aren't missing English locales" do
    before do
      I18n.backend.store_translations :en, { browse: { same_key: "value" } }
      I18n.backend.store_translations :cy, { browse: { same_key: "value" } }
    end

    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.same_key]
        },
        {
          locale: :cy,
          keys: %w[browse.same_key]
        }
      ]
    end

    it "outputs nil" do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end

  context "when there are plurals" do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: []
        },
        {
          locale: :cy,
          keys: %w[browse.plurals.one browse.fake_plurals.other]
        }
      ]
    end

    it "doesn't include them in the report" do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end
end
