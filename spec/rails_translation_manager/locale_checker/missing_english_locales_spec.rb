# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MissingEnglishLocales do
  context 'where there are missing English locales' do
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

    it 'outputs the missing locales' do
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

    it 'outputs an empty array' do
      expect(described_class.new(all_locales).report)
        .to eq(nil)
    end
  end

  context 'when there are lookalike plurals' do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: []
        },
        {
          locale: :cy,
          keys: %w[browse.fake_plurals.one browse.fake_plurals.fake]
        }
      ]
    end

    it 'includes them when reporting missing locales' do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m Missing English locales, either remove these keys from the foreign locales or add them to the English locales

            \e[1mMissing English keys:\e[22m ["browse.fake_plurals.one", "browse.fake_plurals.fake"]
            \e[1mFound in:\e[22m [:cy]
          OUTPUT
        )
    end
  end

  context 'when there are actual plurals' do
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
