module Kuhsaft
  module Cms
    module PagesHelper

      def content_tab_active(page)
        if page.errors.blank? && page.persisted? && page.translated?
          :active
        end
      end

      def metadata_tab_active(page)
        if page.errors.present? || !page.persisted? || page.redirect? || !page.translated?
          :active
        end
      end
    end
  end
end
