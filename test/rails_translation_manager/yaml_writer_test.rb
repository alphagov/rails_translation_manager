module RailsTranslationManager
  class DummyWriter
    include YAMLWriter
  end

  class WriterTest < Minitest::Test

    def setup
      @output_file = Tempfile.new('fr')
    end

    def teardown
      @output_file.close
      @output_file.unlink
    end

    test 'outputs YAML without the header --- line for consistency with convention' do
      data = {"fr" => {
        key1: [:source, :translation],
        "key2" => ["value", "le value"],
      }}

      DummyWriter.new.write_yaml(output_file, data)

      assert_equal "fr:", File.readlines(output_file).first.strip
    end

    test 'outputs a newline at the end of the YAML for consistency with code editors' do
      data = {"fr" => {
        key1: [:source, :translation],
        "key2" => ["value", "le value"],
      }}

      DummyWriter.new.write_yaml(output_file, data)

      assert_match /\n$/, File.readlines(output_file).last
    end

    test 'strips whitespace from the end of lines for consistency with code editors' do
      data = {fr: {
        key1: [:source, :translation],
        "key2" => ["value", nil],
      }}

      DummyWriter.new.write_yaml(output_file, data)

      lines = File.readlines(output_file)
      refute lines.any? { |line| line =~ /\s\n$/ }
    end

  private

    def output_file
      @output_file.path
    end
  end
end

