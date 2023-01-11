# Adding a language's plural form

We maintain our own [plurals.rb][1] configuration file. This is used for plural
rules that don't exist in [rails-i18n][2].

If there is a missing plural rule (fails plural validator) then we can add the
rule to our [plurals.rb][1] file. Plural rules for most languages can be found
on the [unicode website][3] (cardinal type).

## Editing plural forms

Keys with incorrect plural forms are more complex to adjust. If there are keys with additional unnecessary plural forms, they can be deleted:

```
sed -i '' '/^ *one:/d' config/locales/xx.yml
```

Keys which need a plural form added can be automated with caution. If every key of a specific translation needs the new plural added, it can be done by adding a blank key before every `other:` key:

```
perl -0777 -p -i -e 's/\n(\s+)other:/\n\1many:\n\1other:/g' config/locales/xx.yml
```

Or if only a specific key needs the plural added:

```
perl -0777 -p -i -e 's/(key_with_missing_plural:\n)(\s+)/\1\2zero:\n\2/g' config/locales/xx.yml
```

[1]: https://github.com/alphagov/rails_translation_manager/blob/main/config/locales/plurals.rb
[2]: https://github.com/svenfuchs/rails-i18n
[3]: https://unicode-org.github.io/cldr-staging/charts/latest/supplemental/language_plural_rules.html
