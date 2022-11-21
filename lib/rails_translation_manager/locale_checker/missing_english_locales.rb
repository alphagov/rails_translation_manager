# frozen_string_literal: true

class MissingEnglishLocales < BaseChecker
  include LocaleCheckerHelper

  def report
    grouped_missing_keys = group_keys(missing_english_locales)

    format_missing_english_locales(grouped_missing_keys) if grouped_missing_keys.present?
  end

  private

  def format_missing_english_locales(keys)
    formatted_keys = keys.to_a.map do |group|
      "\e[1mMissing English locales:\e[22m #{group[0]}\n\e[1mFound in:\e[22m #{group[1]}"
    end

    "\e[31m[ERROR]\e[0m Missing English locales, either remove them from the foreign locale files or add them to the English locale files\n\n#{formatted_keys.join("\n\n")}"
  end

  def missing_english_locales
    all_locales.each_with_object({}) do |group, hsh|
      next if group[:locale] == :en

      keys = exclude_plurals(group[:keys])

      missing_keys = keys.reject { |key| I18n.exists?(key) }

      next if missing_keys.blank?

      hsh[group[:locale]] = missing_keys
    end
  end
end
