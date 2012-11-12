module Kuhsaft
  class Engine < ::Rails::Engine
    isolate_namespace Kuhsaft

    # initializer 'kuhsaft.init_stylesheets' do |app|
    #   Sass::Plugin.add_template_location File.join(Kuhsaft::Engine.root, 'app', 'stylesheets'), File.join(Rails.root, 'public', 'stylesheets')
    # end

    # initializer 'kuhsaft.static_assets' do |app|
    #   app.middleware.use ::ActionDispatch::Static, "#{Kuhsaft::Engine.root}/public"
    # end

    # initializer 'kuhsaft.helpers' do |app|
    #   # Include your helpers here or they won't be loaded
    #   ActionView::Base.send :include, Kuhsaft::PagesHelper
    #   ActionView::Base.send :include, Kuhsaft::CmsHelper
    # end

  end
end
