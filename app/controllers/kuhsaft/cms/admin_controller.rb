module Kuhsaft
  module Cms
    class AdminController < ApplicationController
      respond_to :html
      layout 'kuhsaft/cms/application'
      before_filter :set_content_locale

      def url_options
        { content_locale: I18n.locale }.merge(super)
      end

      def set_content_locale
        if params[:content_locale].present?
          I18n.locale = params[:content_locale]
        end
      end
    end
  end
end
