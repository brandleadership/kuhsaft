
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rspec/core/rake_task'

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

desc "Run specs"
RSpec::Core::RakeTask.new

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Kuhsaft'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :setup do
  Dir.chdir('spec/dummy') do
    `bundle exec rake db:create`
    `bundle exec rake db:migrate`
    `bundle exec rake db:test:prepare`
  end
end

task :default => [:spec]
