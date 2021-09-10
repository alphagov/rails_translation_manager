# frozen_string_literal: true

require 'rails_translation_manager'

RSpec.configure do |config|
  config.before do
    I18n.available_locales = %i[en cy]
    config.before { allow($stdout).to receive(:puts) }
  end
end
