# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IncompatiblePlurals do
  context 'when there are missing plurals' do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.some_key.other browse.some_other_key.one]
        }
      ]
    end

    it 'returns the missing plural forms' do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m Incompatible plural forms, for:

            - 'en', with parent 'browse.some_key'. Expected: [:one, :other], actual: [:other]

            - 'en', with parent 'browse.some_other_key'. Expected: [:one, :other], actual: [:one]
          OUTPUT
        )
    end
  end

  context "when there aren't any missing plurals" do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.some_key.other browse.some_key.one]
        }
      ]
    end

    it 'returns nil' do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end

  context "when plural forms aren't available for the locales" do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.some_key.other]
        },
        {
          locale: :cy,
          keys: %w[browse.some_key.other]
        }
      ]
    end

    around do |example|
      load_path = I18n.load_path
      I18n.load_path = I18n.load_path.flatten.reject { |path| path =~ /plural/ }

      example.run

      I18n.load_path = load_path
    end

    it 'outputs the missing plural forms' do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m Incompatible plural forms, for:

            - \e[31m[ERROR]\e[0m Please add plural form for 'en' <link to future documentation>

            - \e[31m[ERROR]\e[0m Please add plural form for 'cy' <link to future documentation>
          OUTPUT
        )
    end
  end

  context 'when there are lookalike plural key groups' do
    let(:all_locales) do
      [
        {
          locale: :en,
          keys: %w[browse.some_key.other browse.some_key.fake_plural]
        }
      ]
    end

    it 'ignores them' do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end
end
