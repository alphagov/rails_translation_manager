# Rails Translation Manager

Rails Translation Manager (RTM) provides validation for locale files, and exposes several rake tasks which can be used to manage your translations. It can only be used on Rails apps.

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

- [Creating locale files](docs/creating-locale-files.md) using RTM
- [Synchronising translation files](docs/synchronising-translation-files.md)
- [Adding a language's plural form](docs/add-language-plural-form.md)

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

Sometimes RTM might remove keys that actually _are_ used by your application. This happens when the keys are referenced dynamically. You can make RTM ignore these keys by creating a `/config/i18n-tasks.yml` file with an `ignore_unused` key. For example:

```yaml
ignore_unused:
  - 'content_item.schema_name.*.{one,other,zero,few,many,two}'
  - 'corporate_information_page.*'
  - 'travel_advice.alert_status.*'
```

#### i18n-tasks

RTM uses [i18n-tasks](https://github.com/glebm/i18n-tasks) under the hood.
For advanced tasks, refer to the i18n-tasks documentation:

- [Move / rename / merge keys](https://github.com/glebm/i18n-tasks#move--rename--merge-keys)
- [Delete keys](https://github.com/glebm/i18n-tasks#delete-keys)

## Licence

[MIT License](LICENSE.txt)
