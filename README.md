# Rails Translation Manager

Support for translation workflow in rails applications.

This gem provides a rails engine which adds rake tasks to manage translation files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_translation_manager'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_translation_manager

## Import/export workflow

The primary usage of this gem is to support translation workflow. The expected
usage is:

1. export translations to a CSV file using:

   ```
   rake translation:export:all[target_directory]
   ```

   or

   ```
   rake translation:export[target_directory,base_locale,target_locale]
   ```

2. send the appropriate CSV file to a translator

3. wait for translation to happen

4. receive translation file back, check it for [character encoding issues](https://github.com/alphagov/character_encoding_cleaner)

5. import the translation file using either:

   ```
   rake translation:import:all[source_directory]
   ```

   or

   ```
   rake translation:import[locale,path]
   ```

   this will generate `.yml` files for each translation

6. commit any changed `.yml` files

   ```
   git add config/locale
   git commit -m 'added new translations'
   ```

## Validation of interpolation keys

The I18n library supports 'interpolation' using the following syntax:

```yaml
en:
  some_view:
    greeting: Hello, %{name}
```

in this case the application can pass in the value of the `name` variable.

If a translation includes an interpolation placeholder which has not been
given a value by the application backend, then a runtime error will be raised.

Unfortunately the placeholder variables sometimes get changed by mistake, or
by translators who are not aware that they should not modify text within the
special curly braces of the interpolation placeholder.

This is obviously not great, and the validation task is intended to guard
against it.

It will check all translation files and report any which contain placeholders
which do not exist in the english file.

```
$ rake translation:validate
Success! No unexpected interpolation keys found.
```

## Rake command reference

### Export a specific locale to CSV

```
rake translation:export[directory,base_locale,target_locale]
```

### Export all locales to CSV files

```
rake translation:export:all[directory]
```

### Import a specific locale CSV to YAML within the app

```
rake translation:import[locale,path]
```

### Import all locale CSV files to YAML within the app

```
rake translation:import:all[directory]
```

### Regenerate all locales from the EN locale - run this after adding keys

```
rake translation:regenerate[directory]
```

### Check translation files for errors

```
rake translation:validate
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
