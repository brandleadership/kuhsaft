require_relative '../../app/models/kuhsaft/placeholder_brick'

module Kuhsaft
  module TouchPlaceholders
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        after_save :touch_placeholders
      end
    end

    def touch_placeholders
      if self.class.placeholder_templates.present?
        self.class.placeholder_templates.each do |template_name|
          related_templates = Kuhsaft::PlaceholderBrick.where(template_name: template_name)
          related_templates.each { |p| p.touch } if related_templates
        end
      end
    end

    module ClassMethods
      def placeholder_templates(*attributes)
        if attributes.empty?
          @shoestrap_placeholder_templates
        else
          @shoestrap_placeholder_templates = attributes
        end
      end
    end
  end
end
