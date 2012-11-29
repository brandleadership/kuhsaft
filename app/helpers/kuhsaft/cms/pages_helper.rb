module Kuhsaft
  module Cms
    module PagesHelper

      def content_tab_active(page)
        :active if page.persisted?
      end

      def metadata_tab_active(page)
        :active unless page.persisted?
      end
    end
  end
end
