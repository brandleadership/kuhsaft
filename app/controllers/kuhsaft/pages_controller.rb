module Kuhsaft
  class PagesController < ApplicationController
    
    respond_to :html
    
    def show
      @page = Kuhsaft::Page.find_translation(params[:slug], params[:translation_locale])
      respond_with @page
    end
  end
end