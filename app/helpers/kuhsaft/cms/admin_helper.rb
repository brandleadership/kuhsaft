module Kuhsaft
  module Cms
    module AdminHelper

      def render_language_switch?
        I18n.available_locales.size > 1
      end

      def link_to_other_locale(locale)
        if @page.present? && @page.invalid?
          path = kuhsaft.edit_cms_page_path(@page, :content_locale => locale)
        else
          path = url_for(:content_locale => locale)
        end
        link_to locale.to_s.upcase, path
      end
    end
  end
end
