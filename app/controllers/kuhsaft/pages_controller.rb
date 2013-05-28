module Kuhsaft
  class PagesController < ::ApplicationController
    respond_to :html

    def index
      @search = params[:search]
      if @search.present?
        @pages = Kuhsaft::Page.search(Kuhsaft::Page.locale_attr(:fulltext) => @search)
      else
        @pages = Kuhsaft::Page.all
      end
    end

    def show
      url = locale.to_s
      url += "/#{params[:url]}" if params[:url].present?
      @page = Kuhsaft::Page.find_by_url(url)

      if @page.present? && @page.redirect? && @page.redirect_url.present?
        redirect_to "/#{@page.redirect_url}"
      elsif @page.present?
        respond_with @page
      elsif @page.blank? && respond_to?(:handle_404)
        handle_404
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end
