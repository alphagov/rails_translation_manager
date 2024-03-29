# frozen_string_literal: true

require "spec_helper"

RSpec.describe MissingForeignLocales do
  context "when there are missing foreign locales" do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.same_key browse.extra_nested_key.nest]
        },
        {
          locale: :cy,
          keys: %w[browse.same_key]
        },
        {
          locale: :fr,
          keys: %w[browse.same_key]
        }
      ]
    end

    before do
      I18n.available_locales << %i[fr]
    end

    it "outputs the missing locales and groups them by common keys" do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m Missing foreign locales, either add these keys to the foreign locales or remove them from the English locales\e[0m

            \e[1mMissing foreign keys:\e[22m ["browse.extra_nested_key.nest"]
            \e[1mAbsent from:\e[22m [:cy, :fr]
          OUTPUT
        )
    end
  end

  context "when there aren't missing foreign locales" do
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
          keys: %w[browse.plurals.one browse.fake_plurals.other]
        },
        {
          locale: :cy,
          keys: []
        }
      ]
    end

    it "doesn't include them in the report" do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end
end
