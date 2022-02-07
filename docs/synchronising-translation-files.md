### Synchronising translation files

Common issues with locale files can be identified through the `LocaleChecker`
class (e.g., in an automated test). Some can be fixed automatically; others may
require manual correction.

Keys which exist in some translations but not others can be added with a rake task:

```
rake translation:add_missing
```

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
