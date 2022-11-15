# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UndeclaredLocaleFiles do
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

  context 'when there are undeclared locales' do
    before do
      I18n.available_locales = [:en]
    end

    it 'outputs the missing locales' do
      expect(described_class.new(all_locales).report)
        .to eq(
          <<~OUTPUT.chomp
            \e[31m[ERROR]\e[0m Undeclared locale file(s) detected for:

            cy

            \e[1mEither declare these locale files or remove them from your locale files directory.\e[22m
          OUTPUT
        )
    end
  end

  context "when there aren't undeclared locales" do
    before do
      I18n.available_locales = %i[en cy]
    end

    it 'outputs nil' do
      expect(described_class.new(all_locales).report)
        .to be_nil
    end
  end
end
