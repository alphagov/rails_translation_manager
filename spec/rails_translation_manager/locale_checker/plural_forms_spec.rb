# frozen_string_literal: true

require "spec_helper"

RSpec.describe PluralForms do
  it "returns plural forms" do
    expect(described_class.all).to include(
      { cy: %i[few many one other two zero], en: %i[one other] }
    )
  end

  context "when there are missing plural forms" do
    around do |example|
      load_path = I18n.load_path
      # strips I18n of all pluralization files (rules)
      I18n.load_path = I18n.load_path.flatten.reject { |path| path =~ /plural/ }

      example.run

      I18n.load_path = load_path
    end

    it "returns nil for associated locales" do
      expect(described_class.all).to include({ cy: nil, en: nil })
    end
  end
end
