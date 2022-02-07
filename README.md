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

## Licence

[MIT License](LICENSE.txt)

## Versioning policy

We use [semantic versioning](http://semver.org/), and bump the version
on master only. Please don't submit your own proposed version numbers.
