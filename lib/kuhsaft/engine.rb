module Kuhsaft
  class ImageSizeDelegator
    def method_missing(method, *args, &block)
      Kuhsaft::ImageSize.send(method, *args, &block)
    rescue NoMethodError
      super
    end
  end

  class Engine < ::Rails::Engine
    isolate_namespace Kuhsaft

    config.i18n.fallbacks = [:de]
    config.i18n.load_path += Dir[Kuhsaft::Engine.root.join('config', 'locales', '**', '*.{yml}').to_s]

    # defaults to nil
    config.sublime_video_token = nil

    # delegate image size config to ImageSize class
    config.image_sizes = ImageSizeDelegator.new

    initializer 'kuhsaft.initialize_haml_dependency_tracker' do |app|
      require 'action_view/dependency_tracker'
      ActionView::DependencyTracker.register_tracker :haml, ActionView::DependencyTracker::ERBTracker
    end
  end
end
