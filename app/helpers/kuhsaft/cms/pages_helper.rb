module Kuhsaft
  module Cms
    module PagesHelper

      def content_tab_active(page)
        unless hide_content_tab?(page)
          :active
        end
      end

      def metadata_tab_active(page)
        if hide_content_tab?(page)
          :active
        end
      end

      def hide_content_tab?(page)
        page.redirect? || !page.translated? || !page.persisted? || page.errors.present?
      end
    end
  end
end
