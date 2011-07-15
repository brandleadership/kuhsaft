module Kuhsaft
  class PagesController < ApplicationController
    
    respond_to :html
    before_filter :complete_url
    
    def show
      @page = Kuhsaft::Page.find_by_url(params[:url])
      respond_with @page
    end
    
    private
    def complete_url
      params[:url] = "#{params[:locale]}/#{params[:url]}" if params[:url].present? && params[:locale].present?
    end
  end
end