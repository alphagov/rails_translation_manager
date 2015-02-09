# encoding: utf-8
require 'test_helper'
require 'rails_translation_manager/validator'
require 'tmpdir'
require 'fileutils'

module RailsTranslationManager
  class ValidatorTest < Minitest::Test
    def setup
      @translation_path = Dir.mktmpdir
      @translation_validator = Validator.new(@translation_path)
    end

    def teardown
      FileUtils.remove_entry_secure(@translation_path)
    end

    def create_translation_file(locale, content)
      File.open(File.join(@translation_path, "#{locale}.yml"), "w") do |f|
        f.write(content.lstrip)
      end
    end

    test "can create a flattened list of substitutions" do
      translation_file = YAML.load(%q{
en:
  view: View '%{title}'
  test: foo
})
      expected = [Validator::TranslationEntry.new(%w{en view}, "View '%{title}'")]
      assert_equal expected, @translation_validator.substitutions_in(translation_file)
    end

    test "detects extra substitution keys" do
      create_translation_file("en", %q{
en:
  document:
    view: View '%{title}'
})
      create_translation_file("sr", %q{
sr:
  document:
    view: Pročitajte '%{naslov}'
})
      errors = Validator.new(@translation_path).check!

      expected = %q{Key "sr.document.view": Extra substitutions: ["naslov"]. Missing substitutions: ["title"].}
      assert_equal [expected], errors.map(&:to_s)
    end
  end
end
