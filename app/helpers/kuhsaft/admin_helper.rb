module Kuhsaft
  module AdminHelper
    #
    # When rendering the layout of our host application,
    # the paths of the host application are not visible to the engine
    # therefore we delegate all failing helper calls to 'main_app',
    # which is our host application
    #
    def method_missing(method, *args, &block)
      main_app.send(method, *args, &block)
    rescue NoMethodError
      super
    end

    def sublime_video_include_tag
      token = Kuhsaft::Engine.config.sublime_video_token
      javascript_include_tag "//cdn.sublimevideo.net/js/#{token}-beta.js"
    end
  end
end
