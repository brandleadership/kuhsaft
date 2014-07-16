module Kuhsaft
  module Cms
    module PagesHelper
      def content_tab_active(page)
        :active unless hide_content_tab?(page)
      end

      def metadata_tab_active(page)
        :active if hide_content_tab?(page)
      end

      def hide_content_tab?(page)
        page.page_type == Kuhsaft::PageType::REDIRECT || !page.translated? || !page.persisted? || page.errors.present?
      end
    end
  end
end
