# frozen_string_literal: true

require "spec_helper"

RSpec.describe LocaleCheckerHelper do
  include LocaleCheckerHelper

  describe "#exclude_plurals" do
    it "excludes plural groups" do
      expect(exclude_plurals(%w[key.one key.other]))
        .to eq([])
    end

    it "doesn't exclude non-plurals" do
      expect(exclude_plurals(%w[thing.bing red.blue]))
        .to eq(%w[thing.bing red.blue])
    end
  end

  describe "#group_keys" do
    it "groups locales by keys" do
      keys = {
        en: %w[key.first key.second],
        fr: %w[key.first key.second],
        es: %w[key.second]
      }

      expect(group_keys(keys))
        .to eq(
          {
            %w[key.first key.second] => %i[en fr],
            %w[key.second] => %i[es]
          }
        )
    end
  end

  describe "#english_keys_excluding_plurals" do
    it "returns english keys excluding plurals" do
      keys = [
        { locale: :en, keys: %w[key.english plural.other] },
        { locale: :fr, keys: %w[key.french] }
      ]

      expect(english_keys_excluding_plurals(keys))
        .to eq(%w[key.english])
    end
  end

  describe "#key_is_plural?" do
    it "returns true if key is a plural keyword" do
      expect(key_is_plural?("other"))
        .to eq(true)
    end

    it "returns false if key isn't a plural keyword" do
      expect(key_is_plural?("random"))
        .to eq(false)
    end
  end
end
