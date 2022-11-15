# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsTranslationManager do
  describe '.locale_root' do
    it 'uses the value of the environment variable RAILS_TRANSLATION_MANAGER_LOCALE_ROOT if this is set' do
      ClimateControl.modify(RAILS_TRANSLATION_MANAGER_LOCALE_ROOT: '/path/to/locales') do
        expect(RailsTranslationManager.locale_root).to eq(Pathname.new('/path/to/locales'))
      end
    end

    it "will fall back to Rails default locale location if the environment isn't set" do
      allow(Rails).to receive(:root).and_return(Pathname.new('/rails'))

      ClimateControl.modify(RAILS_TRANSLATION_MANAGER_LOCALE_ROOT: nil) do
        expect(RailsTranslationManager.locale_root).to eq(Pathname.new('/rails/config/locales'))
      end
    end
  end
end
