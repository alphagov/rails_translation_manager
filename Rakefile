require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new("test") do |t|
  t.description = "Run tests"
  t.ruby_opts << "-rubygems"
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

task :default => :test
