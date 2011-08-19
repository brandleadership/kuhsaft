# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kuhsaft/version"

Gem::Specification.new do |s|
  s.name        = "kuhsaft"
  s.version     = Kuhsaft::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Immanuel Häussermann", "Felipe Kaufmann", "Phil Schilter"]
  s.email       = "developers@screenconcept.ch"
  s.homepage    = "http://github.com/screenconcept/kuhsaft"
  s.summary     = %q{A tool that helps you to manage your content within your app.}
  s.description = %q{Kuhsaft is a Rails engine that offers a simple CMS.}

  s.rubyforge_project = "kuhsaft"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rspec-rails', '>= 2.6'
  s.add_development_dependency 'factory_girl_rails', '>= 2.0'
  s.add_development_dependency 'capybara', '>= 0.4.0'
  s.add_development_dependency 'ruby-debug'
  s.add_development_dependency 'sqlite3-ruby', '1.2.5'
  s.add_development_dependency 'guard', '>= 0.6'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'growl'

  s.add_dependency 'rails', '~>3.0'
  s.add_dependency 'haml', '~> 3.1'
  s.add_dependency 'compass', '>= 0.11.1'
  s.add_dependency 'simple_form', '>= 1.4'
  s.add_dependency 'carrierwave', '>= 0.5.7'
  s.add_dependency 'rmagick', '2.12.2'
  s.add_dependency 'rdiscount', '>= 1.6'
  s.add_dependency 'acts-as-taggable-on', '>= 2.0.6'
end
