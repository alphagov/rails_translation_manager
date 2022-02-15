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

- [Adding and editing plural forms](docs/adding-editing-plural-forms.md)
- [Rake command reference](docs/rake-command-reference.md)
- [Translating locale files](docs/translating-locale-files.md) using RTM

#### i18n-tasks

RTM uses [i18n-tasks](https://github.com/glebm/i18n-tasks) under the hood.
For advanced tasks, refer to the i18n-tasks documentation:

- [Move / rename / merge keys](https://github.com/glebm/i18n-tasks#move--rename--merge-keys)
- [Delete keys](https://github.com/glebm/i18n-tasks#delete-keys)

## Licence

[MIT License](LICENSE.txt)
