# Rails Translation Manager

Rails Translation Manager (RTM) provides a Rails engine which adds rake tasks to manage translation
files.

## Technical documentation

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_translation_manager'
```

After a `bundle install`, this will make a number of rake tasks available to your application.
Run `bundle exec rake -T | grep translation:` for a list of tasks (or look at [translation.rake](https://github.com/alphagov/rails_translation_manager/blob/master/lib/tasks/translation.rake)).

You will now also be able to run tests against your locale files to ensure that they are valid.
Create a test file as follows.

#### Minitest

```ruby
class LocalesValidationTest < ActiveSupport::TestCase
  test "should validate all locale files" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml")
    assert checker.validate_locales
  end
end
```

#### RSpec

```ruby
RSpec.describe "locales files" do
  it "should meet all locale validation requirements" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*/*.yml")
    expect(checker.validate_locales).to be_truthy
  end
end
```

### Running the application


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

### Further documentation

- [Creating locale files](docs/creating-locale-files.md) using Rails Translation Manager

#### Rake command reference

Export a specific locale to CSV:

```
rake translation:export[directory,base_locale,target_locale]
```

Export all locales to CSV files:

```
rake translation:export:all[directory]
```

Import a specific locale CSV to YAML within the app:

```
rake translation:import[locale,path]
```

Import all locale CSV files to YAML within the app:

```
rake translation:import:all[directory]
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
