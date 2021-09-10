# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LocaleCheckerHelper do
  include LocaleCheckerHelper

  describe '#exclude_plurals' do
    it 'excludes plural groups' do
      expect(exclude_plurals(%w[key.one key.other]))
        .to eq([])
    end

    it "doesn't exclude non-plurals" do
      expect(exclude_plurals(%w[thing.bing red.blue]))
        .to eq(%w[thing.bing red.blue])
    end

    it "doesn't exclude plural lookalikes" do
      expect(exclude_plurals(%w[key.one key.not_a_plural]))
        .to eq(%w[key.one key.not_a_plural])
    end
  end

  describe '#group_locales_by_keys' do
    it 'groups locales by keys' do
      keys = {
        en: ['key.first', 'key.second'],
        fr: ['key.first', 'key.second'],
        es: ['key.second']
      }

      expect(group_keys(keys))
        .to eq(
          {
            ['key.first', 'key.second'] => %i[en fr],
            ['key.second'] => %i[es]
          }
        )
    end
  end

  describe '#english_keys_excluding_plurals' do
    it 'returns english keys excluding plurals' do
      keys = [
        { locale: :en, keys: ['key.english', 'plural.other'] },
        { locale: :fr, keys: ['key.french'] }
      ]

      expect(english_keys_excluding_plurals(keys))
        .to eq(['key.english'])
    end
  end
end
