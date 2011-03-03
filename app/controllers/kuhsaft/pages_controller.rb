module Kuhsaft
  class PagesController < ApplicationController
    
    respond_to :html
    
    def show
      @page = Kuhsaft::LocalizedPage.where('slug = ?', params[:slug]).first
      respond_with @page
    end
  end
end