# Adding a language's plural form

We maintain our own [plurals.rb](https://github.com/alphagov/rails_translation_manager/blob/master/config/locales/plurals.rb) configuration file. If adding a language to Rails Translation Manager, that doesn't exist in [rails-i18n](https://github.com/svenfuchs/rails-i18n), you may need to edit this file.

This config is needed to correctly distinguish the [plural rules](https://www.unicode.org/cldr/cldr-aux/charts/34/supplemental/language_plural_rules.html) for locales not included in `rails-i18n`, as it is needed for plural validation checks.

Note that there is currently a [duplicate list in `govuk_app_config](https://github.com/alphagov/govuk_app_config/blob/main/lib/govuk_app_config/govuk_i18n.rb). The intention is for this to be removed and for the Rails Translation Manager version to be the sole version.
