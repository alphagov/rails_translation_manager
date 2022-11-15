# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MissingDeclaredLocales do
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

  context 'when there are missing locales' do
    before do
      I18n.available_locales = %i[en CY pt]
    end

    it 'outputs the missing locales' do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m No locale files detected for:

            pt

            \e[1mEither create these locale files or remove these locales from your I18n `available_locales` config.\e[22m
          OUTPUT
        )
    end
  end

  context "when there aren't missing locales" do
    before do
      I18n.available_locales = %i[en cy]
    end

    it 'outputs nil' do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end
end
