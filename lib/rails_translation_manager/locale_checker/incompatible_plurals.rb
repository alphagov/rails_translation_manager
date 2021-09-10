# frozen_string_literal: true

class IncompatiblePlurals < BaseChecker
  include LocaleCheckerHelper

  def report
    format_incompatible_plurals if incompatible_plurals.present?
  end

  private

  def format_incompatible_plurals
    <<~OUTPUT.chomp
      \e[31m[ERROR]\e[0m Incompatible plural forms, for:

      #{incompatible_plurals.join("\n\n")}

      #{non_plural_keys_message}
    OUTPUT
  end

  def incompatible_plurals
    @incompatible_plurals ||= grouped_plural_keys_for_locale.flat_map do |plural_keys_for_locale|
      locale = plural_keys_for_locale[:locale]

      if all_plural_forms[locale].blank?
        missing_plural_form_message(locale)
      else
        missing_plural_keys(plural_keys_for_locale).compact
      end
    end
  end

  def missing_plural_form_message(locale)
    "- \e[31m[ERROR]\e[0m Please add plural form for '#{locale}' <link to future documentation>"
  end

  def non_plural_keys_message
    "\e[1mIf the keys reported above are not plurals, rename them avoiding plural keywords: #{PLURAL_KEYS}\e[22m"
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
        grouped_plurals: grouped_plural_keys(only_plurals(locale[:keys]), locale[:locale])
      }
    end
  end

  def grouped_plural_keys(keys, _locale)
    group_by_parent_keys(keys).map do |plural_key_group|
      {
        parent: plural_key_group.first,
        keys: plural_key_group.last.map { |key_chain| key_chain.split(".").last.to_sym }
      }
    end
  end

  def group_by_parent_keys(keys)
    keys.group_by do |key|
      key.split('.')[0..-2].join('.')
    end
  end

  def only_plurals(keys)
    keys.select { |key| key_is_plural?(key) }
  end

  def all_plural_forms
    @all_plural_forms ||= PluralForms.all
  end
end
