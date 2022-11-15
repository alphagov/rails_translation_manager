# frozen_string_literal: true

require 'rake'

RSpec.configure do |config|
  config.before(:suite) do
    Dir.glob('lib/tasks/*.rake').each { |r| Rake::DefaultLoader.new.load r }
  end
end
