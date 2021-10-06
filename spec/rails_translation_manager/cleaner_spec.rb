require 'spec_helper'

RSpec.describe RailsTranslationManager::Cleaner do

  before(:each) do
    FileUtils.cp('spec/locales/cleaner/with_whitespace.yml', 'tmp/')
  end

  it 'removes whitespace at the end of the line' do
    described_class.new('tmp').clean
    expect(FileUtils.compare_file('tmp/with_whitespace.yml', 'spec/locales/cleaner/clean.yml')).to be_truthy
  end
end
