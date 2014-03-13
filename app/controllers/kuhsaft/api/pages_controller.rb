module Kuhsaft
  module Api
    class PagesController < ActionController::Base
      layout :false
      respond_to :json

      def index
        I18n.locale = params[:locale]
        @pages = Kuhsaft::Page.unscoped.published.content_page
        render json: @pages.as_json
      end
    end
  end
end
