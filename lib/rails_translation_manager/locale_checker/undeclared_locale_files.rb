# frozen_string_literal: true

class UndeclaredLocaleFiles < BaseChecker
  include LocaleCheckerHelper

  def report
    diff = compare
    format_error_message(diff) unless diff.empty?
  end

  private

  def format_error_message(locales)
    <<~OUTPUT.chomp
    \e[31m[ERROR]\e[0m Undeclared locale file(s) detected for:

    #{locales.join("\n\n")}

    \e[1mEither declare these locale files or remove them from your locale files directory.\e[22m
    OUTPUT
  end

  def actual_locales
    all_locales.map { |l| l[:locale] }
  end

  def compare
    actual_locales - I18n.available_locales
  end
end
