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

      def model_attribute_field(resource, column_name, f)
        if resource.class.respond_to?(:uploaders) && resource.class.uploaders.keys.include?(column_name.to_sym)
          f.input column_name, as: :file
        elsif association_class(resource, column_name) == Kuhsaft::Page
          route_input f, column_name, page_routes
        elsif column_name == :link_url || column_name == :link
          route_input f, column_name, user_selectable_routes
        elsif column_name.to_s.end_with? '_id'
          f.association column_name.to_s.gsub(/_id$/, '').to_sym
        elsif column_name == :body
          f.input column_name, input_html: { class: 'ckeditor text required' }
        else
          f.input column_name
        end
      end

      def route_input(form, column_name, selectable_routes)
        list_name = "routes_#{column_name}"
        haml_tag :datalist, id: list_name, name: list_name do
          selectable_routes.each { |route| haml_tag :option, value: route }
        end
        form.input column_name, input_html: { list: list_name }, as: 'string'
      end

      def association_class(resource, column_name)
        association = resource.class.reflect_on_all_associations.find { |r| r.name == column_name.to_sym }
        association_class = association.try :class_name
        association_class.present? ? association_class.constantize : nil
      end

      # here are some route helpers if you need them in your backend
      def all_selectable_routes
        (page_routes + rails_routes).uniq.sort
      end

      def page_routes
        Kuhsaft::Page.all_urls
      end

      def rails_routes
        routes = Rails.application.routes.routes
        routes = routes.select do |r|
          r.verb.match('GET') && !r.requirements.blank? &&
            !r.requirements[:controller].to_s.start_with?('cms') &&
            !r.required_parts.any? &&
            !r.requirements[:controller].to_s.start_with?('rails/')
        end

        routes.map { |r| _routes.url_for(r.requirements.merge only_path: true).strip }.uniq.sort
      end
    end
  end
end
