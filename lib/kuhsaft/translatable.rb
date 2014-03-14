module Kuhsaft
  module Translatable
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def translate(*args)
        args.each do |attr_name|
          define_method attr_name do
            send "#{attr_name}_#{I18n.locale}"
          end

          define_method "#{attr_name}?" do
            send "#{attr_name}_#{I18n.locale}?"
          end

          define_method "#{attr_name}=" do |val|
            send "#{attr_name}_#{I18n.locale}=", val
          end

          define_singleton_method "find_by_#{attr_name}" do |val|
            send "find_by_#{attr_name}_#{I18n.locale}", val
          end
        end
      end

      def locale_attr(attr_name)
        "#{attr_name}_#{I18n.locale}"
      end
    end

    def locale_attr(attr_name)
      "#{attr_name}_#{I18n.locale}"
    end
  end
end
