module Kuhsaft
  class PagesController < ::ApplicationController
    respond_to :html

    def index
      @search = params[:search]
      if @search.present?
        @pages = Kuhsaft::Page.unscoped.published.content_page.search(@search)
      end
    end

    def show
      url = locale.to_s
      url += "/#{params[:url]}" if params[:url].present?
      @page = Kuhsaft::Page.find_by_url(url)

      if @page.present? && @page.redirect? && @page.redirect_url.present?
        redirect_url = @page.redirect_url.sub(/\A\/+/, '') # remove all preceding slashes
        redirect_to "/#{redirect_url}"
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
