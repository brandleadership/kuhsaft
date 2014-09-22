module Kuhsaft
  class PagesController < ::ApplicationController
    respond_to :html
    before_action :find_page_by_url, only: :show

    def index
      @search = params[:search]
      return if @search.blank?
      @pages = Kuhsaft::Page.unscoped.published.content_page.search(@search)
    end

    def show
      if @page.present? && @page.redirect? && @page.redirect_url.present?
        redirect_url = @page.redirect_url.sub(/\A\/+/, '') # remove all preceding slashes
        session[:kuhsaft_referrer] = @page.id
        redirect_to "/#{redirect_url}"
      elsif @page.present?
        respond_with @page
      elsif @page.blank? && respond_to?(:handle_404)
        handle_404
      else
        raise ActionController::RoutingError, 'Not Found'
      end
    end

    def lookup_by_id
      @page = Page.find(params[:id])
      redirect_to "/#{@page.url}"
    end

    private

    def find_page_by_url
      url = locale.to_s
      url += "/#{params[:url]}" if params[:url].present?
      @page = Kuhsaft::Page.find_by_url(url)
    end
  end
end
