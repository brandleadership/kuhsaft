require 'rails'
module Kuhsaft
  class Engine < Rails::Engine
    initializer 'kuhsaft.init_stylesheets' do |app|
      Sass::Plugin.add_template_location File.join(Kuhsaft::Engine.root, 'app', 'stylesheets'), File.join(Rails.root, 'public', 'stylesheets')
    end
    
    initializer 'kuhsaft.static_assets' do |app|
      if app.config.serve_static_assets
        app.middleware.insert 0, ::ActionDispatch::Static, "#{root}/public"
      end
    end
  end
end