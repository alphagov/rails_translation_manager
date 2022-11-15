# frozen_string_literal: true

module LocaleCheckerHelper
  PLURAL_KEYS = %w[zero one two few many other].freeze

  def exclude_plurals(keys)
    keys.reject { |key| key_is_plural?(key) }
  end

  def group_keys(locales)
    locales.keys.group_by do |key|
      locales[key]
    end
  end

  def english_keys_excluding_plurals(all_locales)
    exclude_plurals(all_locales.find { |locale| locale[:locale] == :en }[:keys])
  end

  def key_is_plural?(key)
    PLURAL_KEYS.include?(key.split('.').last)
  end
end
