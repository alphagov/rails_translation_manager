# frozen_string_literal: true

class MissingEnglishLocales
  include LocaleCheckerHelper

  attr_reader :all_locales

  def initialize(all_locales)
    @all_locales = all_locales
  end

  def report
    grouped_missing_keys = group_keys(missing_english_locales)

    format_missing_english_locales(grouped_missing_keys) if grouped_missing_keys.present?
  end

  private

  def format_missing_english_locales(keys)
    formatted_keys = keys.to_a.map do |group|
      "\e[1mMissing English keys:\e[22m #{group[0]}\n\e[1mFound in:\e[22m #{group[1]}"
    end

    "\e[31m[ERROR]\e[0m Missing English locales, either remove these keys from the foreign locales or add them to the English locales\n\n#{formatted_keys.join("\n\n")}"
  end

  def missing_english_locales
    all_locales.each_with_object({}) do |locale, hsh|
      missing_keys = exclude_plurals(locale[:keys]) - english_keys_excluding_plurals(all_locales)

      next if missing_keys.blank?

      hsh[locale[:locale]] = missing_keys
    end
  end
end
