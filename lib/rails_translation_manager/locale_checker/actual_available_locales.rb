# frozen_string_literal: true

class ActualAvailableLocales < BaseChecker

  def report

  end

  private

  def available_locales
    i18n.available_locales
  end

  def actual_locales
    all_locales.each_with_object([]) do |locale, array|
      array << locale[:locale]
  end

  def compare
    actual_locales.each_with_index do |locale, index|
      
  end
end