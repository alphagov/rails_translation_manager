require 'minitest/autorun'

module SimpleTestDsl
  def test(name, &block)
    define_method "test_#{name}", &block
  end
end

Minitest::Test.extend(SimpleTestDsl)
