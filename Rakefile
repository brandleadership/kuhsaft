require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'fileutils'

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
      exec("SELECT 1 FROM pg_user WHERE usename='#{username}'").strip == '1'
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

def within_dummy_app
  Dir.chdir('spec/dummy') do
    ENV['BUNDLE_GEMFILE'] = '../../Gemfile'
    yield
  end
end

desc 'Run specs'
RSpec::Core::RakeTask.new(spec: :setup)

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
  within_dummy_app do
    `bundle exec rake kuhsaft:install:migrations`
    `bundle exec rails generate kuhsaft:install:assets`
    `bundle exec rake db:create`
    `bundle exec rake db:migrate`
    `bundle exec rake db:test:prepare`
    `bundle exec rake db:seed`
  end
end

task default: [:spec]

desc 'start the dummy app'
task :start_dummy do
  within_dummy_app do
    `bundle exec rails server`
  end
end

namespace :dummy_db do
  desc 'migrate in dummy app'
  task :migrate do
    within_dummy_app do
      `bundle exec rake db:migrate 2>&1`
    end
  end
end
