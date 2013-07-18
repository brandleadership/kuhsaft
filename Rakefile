#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |specs|
  specs.rspec_opts = %w{--color}
end

task :default => :spec

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

desc "Run specs"
RSpec::Core::RakeTask.new(:spec => :setup)

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Kuhsaft'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :setup do
  Dir.chdir('spec/dummy') do
    `bundle exec rake kuhsaft:install:migrations`
    `bundle exec rails generate kuhsaft:install:assets`
    `bundle exec rake db:create`
    `bundle exec rake db:migrate`
    `bundle exec rake db:test:prepare`
  end
end

Bundler::GemHelper.install_tasks
