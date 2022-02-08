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
See the [Rake command reference](#rake-command-reference) below.

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

### Running the test suite

To run the test suite just run `bundle exec rake` from within the
`rails_translation_manager` directory.

### Further documentation

- [Creating locale files](docs/creating-locale-files.md) using Rails Translation Manager
- [Synchronising translation files](docs/synchronising-translation-files.md)

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

## Licence

[MIT License](LICENSE.txt)

## Versioning policy

We use [semantic versioning](http://semver.org/), and bump the version
on master only. Please don't submit your own proposed version numbers.
