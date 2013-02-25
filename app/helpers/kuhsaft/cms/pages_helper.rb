module Kuhsaft
  module Cms
    module PagesHelper

      def content_tab_active(page)
        if page.errors.blank?
          :active if page.persisted?
        end
      end

      def metadata_tab_active(page)
        if page.errors.present? || !page.persisted?
          :active
        end
      end
    end
  end
end
