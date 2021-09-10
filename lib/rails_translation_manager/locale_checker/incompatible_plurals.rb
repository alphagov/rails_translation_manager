# frozen_string_literal: true

class IncompatiblePlurals
  include LocaleCheckerHelper

  attr_reader :all_locales

  def initialize(all_locales)
    @all_locales = all_locales
  end

  def report
    "\e[31m[ERROR]\e[0m Incompatible plural forms, for:\n\n#{incompatible_plurals.join("\n\n")}" if incompatible_plurals.present?
  end

  private

  def incompatible_plurals
    @incompatible_plurals ||= grouped_plural_keys_for_locale.flat_map do |plural_keys_for_locale|
      locale = plural_keys_for_locale[:locale]

      if all_plural_forms[locale].blank?
        missing_plural_form(locale)
      else
        missing_plural_keys(plural_keys_for_locale).compact
      end
    end
  end

  def missing_plural_form(locale)
    "- \e[31m[ERROR]\e[0m Please add plural form for '#{locale}' <link to future documentation>"
  end

  def missing_plural_keys(plural_keys_for_locale)
    expected_plural_form = all_plural_forms[plural_keys_for_locale[:locale]].sort

    plural_keys_for_locale[:grouped_plurals].map do |plural_group|
      actual_plural_form = plural_group[:keys].sort

      next if actual_plural_form == expected_plural_form

      "- '#{plural_keys_for_locale[:locale]}', with parent '#{plural_group[:parent]}'. Expected: #{expected_plural_form}, actual: #{actual_plural_form}"
    end
  end

  def grouped_plural_keys_for_locale
    all_locales.map do |locale|
      {
        locale: locale[:locale],
        grouped_plurals: grouped_plural_keys(locale[:keys], locale[:locale]).compact
      }
    end
  end

  def grouped_plural_keys(keys, _locale)
    plural_key_groups = keys.group_by do |key|
      key.split('.')[0..-2].join('.')
    end

    plural_key_groups.map do |plural_key_group|
      # Exclude non-plural groups
      next if exclude_plurals(plural_key_group.last).present?

      {
        parent: plural_key_group.first,
        keys: plural_key_group.last.map { |key_chain| key_chain.split('.').last.to_sym }
      }
    end
  end

  def only_plurals(keys)
    keys.select { |key| key.end_with?('.zero', '.one', '.two', '.few', '.many', '.other') }
  end

  def all_plural_forms
    @all_plural_forms ||= I18n.available_locales.each_with_object({}) do |locale, hsh|
      hsh[locale.downcase] = plural_form(locale)
    end
  end

  def plural_form(locale)
    I18n.with_locale(locale) { I18n.t!('i18n.plural.keys') }.sort
  rescue I18n::MissingTranslationData
    nil
  end
end
