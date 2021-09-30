require 'spec_helper'
require_relative '../../spec/support/tasks'  

describe 'rake tasks' do
  before do
    fake_rails = double()
    fake_rails.stub(:root) { Pathname.new('spec') }
    stub_const("Rails", fake_rails)
  end

  describe 'translation:add_missing', type: :task do
    let(:task) { Rake::Task["translation:add_missing"] }
  
    it 'is executed' do
      expect { task.execute }.to output.to_stdout
    end

    it 'triggers i18n task' do
      allow(I18n::Tasks::CLI).to receive(:start)
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start)
    end
  end

  describe 'translation:normalize', type: :task do
    let(:task) { Rake::Task["translation:normalize"] }
  
    it 'is executed' do
      expect { task.execute }.to_not output.to_stdout
    end

    it 'triggers i18n task' do
      allow(I18n::Tasks::CLI).to receive(:start)
      task.execute
      expect(I18n::Tasks::CLI).to have_received(:start)
    end
  end
end
