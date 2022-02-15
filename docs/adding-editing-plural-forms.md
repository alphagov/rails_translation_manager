# Adding a language's plural form

We maintain our own [plurals.rb](https://github.com/alphagov/rails_translation_manager/blob/master/config/locales/plurals.rb) configuration file. If adding a language to Rails Translation Manager, that doesn't exist in [rails-i18n](https://github.com/svenfuchs/rails-i18n), you may need to edit this file.

This config is needed to correctly distinguish the [plural rules](https://www.unicode.org/cldr/cldr-aux/charts/34/supplemental/language_plural_rules.html) for locales not included in `rails-i18n`, as it is needed for plural validation checks.

Note that there is currently a [duplicate list in `govuk_app_config](https://github.com/alphagov/govuk_app_config/blob/main/lib/govuk_app_config/govuk_i18n.rb). The intention is for this to be removed and for the Rails Translation Manager version to be the sole version.

## Editing plural forms

Keys with incorrect plural forms are more complex to adjust. If there are keys with additional unnecessary plural forms, they can be deleted:

```
sed -i '' '/^ \+one:/d' config/locales/xx.yml
```

This commonly occurs for e.g. Chinese and Vietnamese which are expected to have only an `:other` and not a `:one` form.

Keys which need a plural form added can be automated with caution. If every key of a specific translation needs the new plural added, it can be done by adding a blank key before every `other:` key:

```
perl -0777 -p -i -e 's/\n(\s+)other:/\n\1nmany:\n\1other:/g' config/locales/xx.yml
```

Or if only a specific key needs the plural added:

```
perl -0777 -p -i -e 's/(key_with_missing_plural:\n)(\s+)/\1\2zero:\n\2/g' config/locales/xx.yml
```

This commonly occurs for Slavic languages and Arabic, for example, which have plural forms other than just `:one` and `:other`.
