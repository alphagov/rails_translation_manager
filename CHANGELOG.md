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
