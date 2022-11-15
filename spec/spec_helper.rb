# frozen_string_literal: true

require 'rails_translation_manager'
require 'climate_control'

RSpec.configure do |config|
  config.before do
    I18n.available_locales = %i[en cy]
    config.before { allow($stdout).to receive(:puts) }
  end

  def capture_stdout(&blk)
    old = $stdout
    $stdout = fake = StringIO.new
    blk.call
    fake.string
  ensure
    $stdout = old
  end
end
