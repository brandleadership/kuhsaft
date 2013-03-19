module Kuhsaft
  class PagesController < ApplicationController
    
    respond_to :html
    before_filter :complete_url
    
    def show
      @page = Kuhsaft::Page.find_by_url(params[:url])
      if @page.present?
        respond_with @page
      else
        if respond_to?(:handle_404)
          handle_404
        else
          raise ActionController::RoutingError.new('Not Found')
        end
      end
    end
    
    private
    def complete_url
      params[:url] = "#{params[:locale]}/#{params[:url]}" if params[:url].present? && params[:locale].present?
    end
  end
end