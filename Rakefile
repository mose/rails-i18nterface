#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
require 'bundler/setup'

require "bundler/gem_tasks"
#Bundler::GemHelper.install_tasks

require "rake/testtask"

require "rspec/core/rake_task" # RSpec 2.0

desc "launch rspec tests"
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
    t.pattern = 'spec/{controllers,lib,requests}/*_spec.rb'
  end
end

desc "launch selenium tests on SauceLabs"
task :sauce do
  RSpec::Core::RakeTask.new(:sauce) do |t|
    t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
    t.pattern = 'spec/selenium/*_spec.rb'
  end
end

task :default => :spec
