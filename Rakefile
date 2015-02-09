require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new("test") do |t|
  t.description = "Run tests"
  t.ruby_opts << "-rubygems"
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

require "gem_publisher"
task :publish_gem do |t|
  gem = GemPublisher.publish_if_updated("rails_translation_manager.gemspec", :rubygems)
  puts "Published #{gem}" if gem
end

task :default => :test
