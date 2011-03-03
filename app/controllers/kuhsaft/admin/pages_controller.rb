module Kuhsaft
  module Admin
    class PagesController < ApplicationController
    
      respond_to :html
    
      def index
        @pages = Kuhsaft::Page.root_pages
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
        @page = Kuhsaft::Page.create params[:page]
        @page.save
        respond_with @page, :location => pages_path
      end
    
      def edit
        @page = Kuhsaft::Page.find(params[:id])
        respond_with @page
      end
    
      def update
        @page = Kuhsaft::Page.find(params[:id])
        @page.update_attribute(params[:page])
        respond_with @page, :location => pages_path
      end
    
      def destroy
        @page = Kuhsaft::Page.find(params[:id])
        @page.destroy
        redirect_to pages_path
      end
    end
  end
end