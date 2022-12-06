# 1.6.2

* Load plural rules after initialising app https://github.com/alphagov/rails_translation_manager/pull/61

# 1.6.1

* Audits plural rules and ensures consistent formatting https://github.com/alphagov/rails_translation_manager/pull/57
* Allows all plural rules to be loaded by setting env variable https://github.com/alphagov/rails_translation_manager/pull/58/

# 1.6.0

Update plural file loading https://github.com/alphagov/rails_translation_manager/pull/52
Update missing English keys checker https://github.com/alphagov/rails_translation_manager/pull/53
Add missing plurals for Welsh, Maltese and Hong Kong Chinese.
* https://github.com/alphagov/rails_translation_manager/pull/49
* https://github.com/alphagov/rails_translation_manager/pull/50

# 1.5.2

Add missing plurals for Gujarati and Yiddish https://github.com/alphagov/rails_translation_manager/pull/44

# 1.5.1

Fixes uppercase bug when comparing actual vs available locales. https://github.com/alphagov/rails_translation_manager/pull/43

# 1.5.0

Allow configuring the locale files directory with `RAILS_TRANSLATION_MANAGER_LOCALE_ROOT`. https://github.com/alphagov/rails_translation_manager/pull/38

## 1.4.0

Add `skip_validation` parameter to `LocaleChecker`. https://github.com/alphagov/rails_translation_manager/pull/35

## 1.3.0

Add remove-unused task wrapper. https://github.com/alphagov/rails_translation_manager/pull/32

## 1.2.0

Add two new checker classes. https://github.com/alphagov/rails_translation_manager/pull/30

## 1.1.3

Handle importing files that contain rows with a blank "key". https://github.com/alphagov/rails_translation_manager/pull/28

## 1.1.2

Handle importing files that contain Byte Order Marks. https://github.com/alphagov/rails_translation_manager/pull/27

## 1.1.1

Fix Rails Translation Manager / Rails naming clash for class. https://github.com/alphagov/rails_translation_manager/pull/26

## 1.1.0

Allow multiple files per language to be imported. https://github.com/alphagov/rails_translation_manager/pull/20

## 1.0.0

Adds logic to verify locale files are in sync with each other and have the
correct plural forms. Also introduces RSpec into the Gem which will replace
Minitest in the coming iterations.

Integrates RTM with I18n-tasks. Adds wrappers around `add-missing` & `normalize` tasks, adds Cleaner class to remove the whitespace added by i18n-tasks, adds tests and byebug gem as a debugging tool.

## 0.1.0

Don't change the $LOAD_PATH in translation.rake.

## 0.0.2

Added `steal` rake tasks to copy translations from another app.

## 0.0.1

Initial release.
