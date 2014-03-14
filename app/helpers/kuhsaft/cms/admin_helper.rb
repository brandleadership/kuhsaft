module Kuhsaft
  module Cms
    module AdminHelper
      def render_language_switch?
        I18n.available_locales.size > 1
      end

      def link_to_content_locale(locale)
        action = params[:action]
        if params[:action] == 'create'
          action = 'new'
        elsif params[:action] == 'update'
          action = 'edit'
        end

        link_to locale.to_s.upcase, url_for(
          action: action, content_locale: locale)
      end
    end
  end
end
