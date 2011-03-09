module Kuhsaft
  module Admin
    class PagesController < ApplicationController
      respond_to :html
      layout 'kuhsaft/admin'
      before_filter :set_translation_locale      
      
      def index
        @pages = Kuhsaft::Page.root_pages.positioned
        respond_with @pages
      end
    
      def show
        @page = Kuhsaft::Page.find(params[:id])
        respond_with @page
      end
    
      def new
        @page = Kuhsaft::Page.new
        respond_with @page
      end
    
      def create
        @page = Kuhsaft::Page.create params[:kuhsaft_page]
        @page.save
        respond_with @page, :location => admin_pages_path
      end
    
      def edit
        @page = Kuhsaft::Page.find(params[:id])
        respond_with @page
      end
    
      def update
        @page = Kuhsaft::Page.find(params[:id])
        @page.update_attributes(params[:kuhsaft_page]) if params[:kuhsaft_page].present?
        @page.reposition params[:reposition] if params[:reposition].present?
        respond_with @page, :location => admin_pages_path
      end
    
      def destroy
        @page = Kuhsaft::Page.find(params[:id])
        @page.destroy
        redirect_to admin_pages_path
      end
      
      def set_translation_locale
        Kuhsaft::Page.current_translation_locale = params[:translation_locale] if params[:translation_locale].present?
      end
    end
  end
end