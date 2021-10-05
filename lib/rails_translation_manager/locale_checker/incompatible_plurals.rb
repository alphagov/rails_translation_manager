# frozen_string_literal: true

class IncompatiblePlurals < BaseChecker
  include LocaleCheckerHelper

  def report
    format_plural_errors if plural_errors.present?
  end

  private

  def format_plural_errors
    <<~OUTPUT.chomp
      \e[31m[ERROR]\e[0m Incompatible plural forms, for:

      #{plural_errors.join("\n\n")}

      \e[1mIf the keys reported above are not plurals, rename them avoiding plural keywords: #{PLURAL_KEYS}\e[22m
    OUTPUT
  end

  def plural_errors
    @plural_errors ||= grouped_plural_keys_for_locale.flat_map do |plurals|
      plural_form = all_plural_forms[plurals[:locale]]

      if plural_form.blank?
        "- \e[31m[ERROR]\e[0m Please add plural form for '#{plurals[:locale]}' <link to future documentation>"
      else
        incompatible_plurals(plurals, plural_form)
      end
    end
  end

  def incompatible_plurals(plurals, plural_form)
    error_messages = plurals[:groups].map do |plural_group|
      actual_plural_form = plural_group[:keys].sort

      next if actual_plural_form == plural_form.sort

      "- '#{plurals[:locale]}', with parent '#{plural_group[:parent]}'. Expected: #{plural_form}, actual: #{actual_plural_form}"
    end

    error_messages.compact
  end

  def grouped_plural_keys_for_locale
    all_locales.map do |locale|
      {
        locale: locale[:locale],
        groups: grouped_plural_keys(only_plurals(locale[:keys]))
      }
    end
  end

  def grouped_plural_keys(keys)
    # %w[parent.key parent.other_key] -> [{ parent: "parent", keys: %w[key other_key] }]
    group_by_parent_keys(keys).map do |plural_key_group|
      {
        parent: plural_key_group.first,
        keys: plural_key_group.last.map { |key_chain| key_chain.split(".").last.to_sym }
      }
    end
  end

  def group_by_parent_keys(keys)
    # %w[parent.key parent.other_key] -> { "parent" => %w[parent.key parent.other_key] }
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
