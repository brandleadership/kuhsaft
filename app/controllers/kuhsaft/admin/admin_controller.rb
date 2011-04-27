module Kuhsaft
  module Admin
    class AdminController < ApplicationController
      
      respond_to :html
      layout 'kuhsaft/admin'
      before_filter :set_translation_locale
      
      def default_url_options
        { :locale => params[:locale].presence || :en }
      end
      
      def set_translation_locale
        Kuhsaft::Page.current_translation_locale = params[:locale] if params[:locale].present?
      end
    end
  end
end