# frozen_string_literal: true

class MissingForeignLocales < BaseChecker
  include LocaleCheckerHelper

  def report
    grouped_missing_keys = group_keys(missing_foreign_locales)

    format_missing_foreign_locales(grouped_missing_keys) if grouped_missing_keys.present?
  end

  private

  def format_missing_foreign_locales(keys)
    formatted_keys = keys.to_a.map do |group|
      "\e[1mMissing foreign keys:\e[22m #{group[0]}\n\e[1mAbsent from:\e[22m #{group[1]}"
    end

    "\e[31m[ERROR]\e[0m Missing foreign locales, either add these keys to the foreign locales or remove them from the English locales\e[0m\n\n#{formatted_keys.join("\n\n")}"
  end

  def missing_foreign_locales
    all_locales.each_with_object({}) do |locale, hsh|
      missing_keys = english_keys_excluding_plurals(all_locales) - exclude_plurals(locale[:keys])

      next if missing_keys.blank?

      hsh[locale[:locale]] = missing_keys
    end
  end
end
