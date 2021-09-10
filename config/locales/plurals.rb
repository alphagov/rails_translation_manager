# frozen_string_literal: true

{
  # Dari - this isn't an iso code. Probably should be 'prs' as per ISO 639-3.
  dr: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Latin America and Caribbean Spanish
  "es-419": { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Scottish Gaelic
  gd: { i18n: { plural: { keys: %i[one two few other],
                          rule: lambda do |n|
                            if [1, 11].include?(n)
                              :one
                            elsif [2, 12].include?(n)
                              :two
                            elsif [3, 4, 5, 6, 7, 8, 9, 10, 13, 14, 15, 16, 17, 18, 19].include?(n)
                              :few
                            else
                              :other
                            end
                          end } } },
  # Gujarati
  gu: { i18n: { plural: { keys: %i[one other], rule: ->(n) { [0, 1].include?(n) ? :one : :other } } } },
  # Armenian
  hy: { i18n: { plural: { keys: %i[one other], rule: ->(n) { [0, 1].include?(n) ? :one : :other } } } },
  # Kazakh
  kk: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Pashto
  ps: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Punjabi Shahmukhi
  "pa-pk": { i18n: { plural: { keys: %i[one other], rule: ->(n) { [0, 1].include?(n) ? :one : :other } } } },
  # Sinhalese
  si: { i18n: { plural: { keys: %i[one other], rule: ->(n) { [0, 1].include?(n) ? :one : :other } } } },
  # Somali
  so: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Albanian
  sq: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Norwegian
  no: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Tamil
  ta: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Turkmen
  tk: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Uzbek
  uz: { i18n: { plural: { keys: %i[one other], rule: ->(n) { n == 1 ? :one : :other } } } },
  # Chinese Hong Kong
  'zh-hk' => { i18n: { plural: { keys: %i[other], rule: -> { :other } } } },
  # Chinese Taiwan
  'zh-tw' => { i18n: { plural: { keys: %i[other], rule: -> { :other } } } }
}