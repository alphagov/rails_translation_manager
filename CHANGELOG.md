## unreleased

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
