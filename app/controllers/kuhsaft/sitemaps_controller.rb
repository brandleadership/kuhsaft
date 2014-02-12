module Kuhsaft
  class SitemapsController < ::ApplicationController
    def index
      last_page = Kuhsaft::Page.published.last
      if stale?(:etag => last_page, :last_modified => last_page.updated_at.utc)
        respond_to do |format|
          format.html
          format.xml { @pages = Kuhsaft::Page.published }
        end
      end
    end
  end
end
