# frozen_string_literal: true

module LocaleCheckerHelper
  def exclude_plurals(keys)
    key_groups = keys.group_by do |key|
      key.split('.')[0..-2].join('.')
    end

    # Include lookalike plural groups e.g. browse: ["one", "other", "non-plural"]
    non_plural_keys = key_groups.flat_map do |_parent, keys|
      non_plurals = keys.reject { |key| key.end_with?('.zero', '.one', '.two', '.few', '.many', '.other') }

      keys if non_plurals.present?
    end

    non_plural_keys.compact
  end

  def group_keys(locales)
    locales.keys.group_by do |key|
      locales[key]
    end
  end

  def english_keys_excluding_plurals(all_locales)
    exclude_plurals(all_locales.find { |locale| locale[:locale] == :en }[:keys])
  end
end
