# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "kuhsaft/version"

Gem::Specification.new do |s|
  s.name        = "kuhsaft"
  s.version     = Kuhsaft::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Immanuel Häussermann", "Felipe Kaufmann", "Phil Schilter", "Donat Baier", "Franca Rast"]
  s.email       = "developers@screenconcept.ch"
  s.homepage    = "http://github.com/screenconcept/kuhsaft"
  s.summary     = %q{A tool that helps you to manage your content within your app.}
  s.description = %q{Kuhsaft is a Rails engine that offers a simple CMS.}

  s.rubyforge_project = "kuhsaft"

  s.files         = Dir["{app,config,db,lib,vendor}/**/*"] + ["Rakefile", "README.md"]
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.license = 'MIT'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara', '>= 2.0'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'rake'

  s.add_dependency 'coffee-rails'
  s.add_dependency 'haml', '>= 4.0.3'
  s.add_dependency 'carrierwave'#, '>= 0.7.1'
  s.add_dependency 'mini_magick'#, '>= 3.4'
  s.add_dependency 'rdiscount'#, '>= 1.6'
  s.add_dependency 'ancestry'
  s.add_dependency 'bootstrap-sass'#, '>= 2.2.2.0'
  s.add_dependency 'ckeditor', '4.0.2'
  s.add_dependency 'pg_search'
  s.add_dependency 'htmlentities'

  s.add_dependency 'jquery-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'pry-debugger'
  s.add_dependency 'sass-rails'
  s.add_dependency 'inherited_resources'

  # Rails 4 compatibility
  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'simple_form', '3.0.0.rc'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'bourbon'
end
