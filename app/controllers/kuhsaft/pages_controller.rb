module Kuhsaft
  class PagesController < ApplicationController
    
    respond_to :html
    
    def show
      @page = Kuhsaft::Page.find_by_url(params[:url])
      debugger
      respond_with @page
    end
  end
end