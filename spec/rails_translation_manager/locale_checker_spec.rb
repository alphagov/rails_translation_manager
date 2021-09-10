# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsTranslationManager::LocaleChecker do
  context 'when the locales are valid' do
    it 'outputs a confirmation' do
      expect { described_class.new('spec/locales/in_sync/**/*.yml').validate_locales }
        .to output("Locale files are in sync, nice job!\n").to_stdout
    end

    it 'returns true' do
      expect(described_class.new('spec/locales/in_sync/**/*.yml').validate_locales)
        .to eq(true)
    end
  end

  context 'when the locales are not valid' do
    it 'outputs the report' do
      expect { described_class.new('spec/locales/*.yml').validate_locales }
        .to output(
          <<~OUTPUT.chomp

            \e[31m[ERROR]\e[0m Missing English locales, either remove these keys from the foreign locales or add them to the English locales

            \e[1mMissing English keys:\e[22m ["other_test"]
            \e[1mFound in:\e[22m [:cy]


            \e[31m[ERROR]\e[0m Missing foreign locales, either add these keys to the foreign locales or add remove them from the English locales\e[0m

            \e[1mMissing foreign keys:\e[22m ["test", "wrong_plural"]
            \e[1mAbsent from:\e[22m [:cy]


            \e[31m[ERROR]\e[0m Incompatible plural forms, for:

            - 'en', with parent 'wrong_plural'. Expected: [:one, :other], actual: [:one, :zero]


          OUTPUT
        ).to_stdout
    end

    it 'returns false' do
      expect(described_class.new('spec/locales/*.yml').validate_locales)
        .to eq(false)
    end
  end

  context "when the locale path doesn't relate to any YAML files" do
    it 'outputs an error' do
      expect { described_class.new('some/random/path').validate_locales }
        .to output("No locale files found for the supplied locale path\n").to_stdout
    end

    it 'returns false' do
      expect(described_class.new('some/random/path').validate_locales)
        .to eq(false)
    end
  end
end
