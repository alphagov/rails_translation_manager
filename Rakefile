# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rails_i18n'

Rake::TestTask.new('test') do |t|
  t.description = 'Run tests'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec test]
