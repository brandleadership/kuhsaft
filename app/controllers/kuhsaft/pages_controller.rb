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
      @url = "#{params[:locale]}/#{params[:url]}" if params[:url].present? && params[:locale].present?
      @page = Kuhsaft::Page.find_by_url(@url)
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
  end
end
