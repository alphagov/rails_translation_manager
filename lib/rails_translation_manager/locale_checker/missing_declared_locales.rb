# frozen_string_literal: true

class MissingDeclaredLocales < BaseChecker
  include LocaleCheckerHelper

  def report
    diff = compare
    format_error_message(diff) unless diff.empty?
  end

  private

  def format_error_message(locales)
    <<~OUTPUT.chomp
    \e[31m[ERROR]\e[0m No locale files detected for:

    #{locales.join("\n\n")}

    \e[1mEither create these locale files or remove these locales from your I18n `available_locales` config.\e[22m
    OUTPUT
  end

  def actual_locales
    all_locales.map { |l| l[:locale] }
  end

  def compare
    I18n.available_locales.map(&:downcase) - actual_locales
  end
end
