module Kuhsaft
  module Cms
    class AdminController < ApplicationController
      respond_to :html
      layout 'kuhsaft/cms/application'
      before_filter :set_content_locale

      def set_content_locale
        if params[:content_locale].present?
          I18n.locale = params[:content_locale]
        end
      end

      def current_admin
        dummy = ""
        def dummy.cms_locale
          :de
        end
      end
    end
  end
end
