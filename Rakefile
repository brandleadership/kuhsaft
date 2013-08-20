
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

module Postgres
  class << self
    def exec(query)
      `psql postgres -tAc "#{query}"`
    end

    def user_exists?(username)
      exec("SELECT 1 FROM pg_roles WHERE rolname='#{username}'").strip == '1'
    end

    def drop_user(username)
      puts "dropping user #{username}"
      puts exec("DROP USER #{username}").inspect
    end

    def create_user(username)
      user_exists?(username) ? false : `createuser -s #{username}`
    end
  end
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

desc 'set up the dummy app for testing'
task :setup do
  Postgres.create_user 'screenconcept'
  Dir.chdir('spec/dummy') do
    `bundle exec rake kuhsaft:install:migrations`
    `bundle exec rails generate kuhsaft:install:assets`
    `bundle exec rake db:create`
    `bundle exec rake db:migrate`
    `bundle exec rake db:test:prepare`
  end
end

task :default => [:spec]

desc 'start the dummy app'
task :start_dummy do
  Dir.chdir('spec/dummy') do
    ENV['BUNDLE_GEMFILE'] = '../../Gemfile'
    `bundle exec rails server`
  end
end
