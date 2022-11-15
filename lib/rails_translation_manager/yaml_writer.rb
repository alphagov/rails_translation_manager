# frozen_string_literal: true

require 'yaml'

module YAMLWriter
  # `to_yaml` outputs an initial '---\n', which is supposed to be a document
  # separator. We don't want this in the written locale files, so we serialize
  # to a string, remove the header and any trailing whitehspace, and write to
  # the file.
  def write_yaml(filepath, data)
    File.open(filepath, 'w') do |f|
      yaml = data.to_yaml(separator: '')
      yaml_without_header = yaml.split("\n").map { |l| l.gsub(/\s+$/, '') }[1..].join("\n")
      f.write(yaml_without_header)
      f.puts
    end
  end
end
