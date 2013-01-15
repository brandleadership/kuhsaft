module Kuhsaft
  module ApplicationHelper

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
  end
end
