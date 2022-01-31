# Rails Translation Manager

Support for translation workflow in rails applications.

## Nomenclature

- **CSV**: comma separated values, a tabular data format which can be loaded into a
           spreadsheet package
- **I18n**: an abbreviation of 'internationalisation', which is the process of adding
            support for multiple locales and languages to an application.
            `I18n` is also the name of a ruby gem which supports
            internationalisation in ruby applications.
- **interpolation**: a technique used in I18n whereby data is inserted ("interpolated")
                     into a translated string of text, for example `Hello %{name}`
                     would become `Hello Sarah` if the variable `name` had the
                     value `Sarah`.
- **YAML**: YAML Ain't Markup Language, a textual data format used (in this case) for storing
            translation strings in rails applications

## Technical documentation

This gem provides a rails engine which adds rake tasks to manage translation
files.

It is intended to be included within your rails application by referencing it
as a dependency in your `Gemfile`. You will then be able to use the rake tasks
to manage your translation files and import/export translation strings.

### Dependencies

To date it has only been tested with a rails 3.2.18 app, but it should work with later (and older) rails apps as well.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_translation_manager'
```

And then execute:

    $ bundle

The gem depends on your rails application environment so it would not make
sense to install this gem stand-alone.

### Running the application

The primary usage of this gem is to support translation workflow.

Once you have installed the gem into your application as described above, the
expected usage is:

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

### Validation of interpolation keys

A second feature supported by this library is the validation of interpolation
keys.

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

### Stealing translations from another app

A third feature is the ability to "steal" one or more locales from an existing
application. This functionality works by providing a mapping file, which defines
how the translation keys in the the source app's files map to those in the app
the gem is installed in.

For example, given a locale file like this in the app to "steal" from:

```yaml
es:
  document:
    type:
      case_study: Caso de estudio
      consultation: Consulta
```

and a mapping file like this:

```yaml
document.type: content_item.format
```

running `rake translation:steal[es,../other_app,mapping_file_path.yml]` will
result in the following locale file being created:

```yaml
es:
  content_item:
    format:
      case_study: Caso de estudio
      consultation: Consulta
```

The mapping file can live anywhere, as long as the full path (including filename)
is given in the rake task invocation.

The process will preserve data already in the output file if it is not
referenced in the mapping, but will always override data belonging to keys
that are in the mapping.


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

### Rake command reference

#### Export a specific locale to CSV

```
rake translation:export[directory,base_locale,target_locale]
```

#### Export all locales to CSV files

```
rake translation:export:all[directory]
```

#### Import a specific locale CSV to YAML within the app

```
rake translation:import[locale,path]
```

#### Import all locale CSV files to YAML within the app

```
rake translation:import:all[directory]
```

#### 

#### Regenerate all locales from the EN locale - run this after adding keys

```
rake translation:regenerate[directory]
```

#### Check translation files for errors

```
rake translation:validate
```

#### Steal a specific locale file from another app

```
rake translation:steal[locale,source_app_path,mapping_file_path]
```

#### Steal all locale files from another app

```
rake translation:steal:all[source_app_path,mapping_file_path]
```

### Running the test suite

To run the test suite just run `bundle exec rake` from within the
`rails_translation_manager` directory.

You will need to clone the repository locally and run `bundle install` the
first time you do this, eg.:

```sh
$ git clone git@github.com:alphagov/rails_translation_manager.git
$ cd rails_translation_manager
$ bundle install
$ bundle exec rake
...
```

## Licence

[MIT License](LICENSE.txt)

## Versioning policy

We use [semantic versioning](http://semver.org/), and bump the version
on master only. Please don't submit your own proposed version numbers.
