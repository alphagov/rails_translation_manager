# Rake command reference

±Export a specific locale to CSV:

```
rake translation:export[directory,base_locale,target_locale]
```

±Export all locales to CSV files:

```
rake translation:export:all[directory]
```

> ± These tasks won't work in [multi-file setups](#multi-file-setups).

Import a specific locale CSV to YAML within the app:

```
rake translation:import[locale,path,multiple_files_per_language]
```

Import all locale CSV files to YAML within the app:

```
rake translation:import:all[directory,multiple_files_per_language]
```

> The `multiple_files_per_language` parameter is optional and defaults to `false`. See [multi-file setups](#multi-file-setups).

Add missing keys with placeholders:

```
rake translation:add_missing
```

Normalize your locales (remove whitespace, sort keys alphabetically, etc):

```
rake translation:normalize
```

Remove keys that are not used anywhere in your application:

```
rake translation:remove_unused
```

Sometimes RTM might remove keys that actually _are_ used by your application. This happens when the keys are referenced dynamically. You can make RTM ignore these keys by creating a `/config/i18n-tasks.yml` file with an `ignore_unused` key. For example:

```yaml
ignore_unused:
  - 'content_item.schema_name.*.{one,other,zero,few,many,two}'
  - 'corporate_information_page.*'
  - 'travel_advice.alert_status.*'
```

## Multi-file setups

Locale files can follow a single-file structure. For example:

```
config/
  locales/
    en/
      en.yml
    fr/
      fr.yml
```

They can also follow a multi-file structure. For example:

```
config/
  locales/
    en/
      bar.yml
      foo.yml
    fr/
      bar.yml
      foo.yml
```

Some tasks will work with both structures, but others are limited to only one structure type, due to lack of development time. Ideally, all tasks would work with both types.
