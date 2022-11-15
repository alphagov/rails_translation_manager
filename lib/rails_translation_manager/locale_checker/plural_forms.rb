# frozen_string_literal: true

class PluralForms
  def self.all
    I18n.available_locales.each_with_object({}) do |locale, hsh|
      begin
        # fetches plural form (rule) from rails-i18n for locale
        plural_form = I18n.with_locale(locale) { I18n.t!('i18n.plural.keys') }.sort
      rescue I18n::MissingTranslationData
        plural_form = nil
      end

      hsh[locale.downcase] = plural_form
    end
  end
end
