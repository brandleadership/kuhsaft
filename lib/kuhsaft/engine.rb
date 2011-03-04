require 'rails'
module Kuhsaft
  class Engine < Rails::Engine
    initializer "kuhsaft.init_stylesheets" do |app|
      Sass::Plugin.add_template_location File.join(Kuhsaft::Engine.root, 'app', 'stylesheets'), File.join(Rails.root, 'public', 'stylesheets')
   end
  end
end