# frozen_string_literal: true

require "rails_translation_manager"
require "climate_control"

RSpec.configure do |config|
  config.before do
    I18n.available_locales = %i[en cy]
    config.before { allow($stdout).to receive(:puts) }
    I18n.backend.store_translations :en, i18n: { plural: { keys: %i[one other],
                                                           rule:
                                                             lambda do |n|
                                                               n == 1 ? :one : :other
                                                             end } }
    I18n.backend.store_translations :cy, i18n: { plural: { keys: %i[zero one two few many other],
                                                           rule:
                                                             lambda do |n|
                                                               case n
                                                               when 0 then :zero
                                                               when 1 then :one
                                                               when 2 then :two
                                                               when 3 then :few
                                                               when 6 then :many
                                                               else :other
                                                               end
                                                             end } }

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
