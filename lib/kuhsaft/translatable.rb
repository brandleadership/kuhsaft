module Kuhsaft
  module Translatable
    def self.included(base)
      base.extend ClassMethods
    end

    extend self

    module ClassMethods
      def translate(*args)
        args.each do |attr_name|
          define_localized_attr_getter attr_name
          define_localized_attr_setter attr_name
          define_localized_attr_finder attr_name
          define_localized_attr_predicate_method attr_name
        end
      end

      def define_localized_attr_getter(attr_name)
        define_method attr_name do
          send "#{attr_name}_#{locale_for_attr_name}"
        end
      end

      def define_localized_attr_predicate_method(attr_name)
        define_method "#{attr_name}?" do
          send "#{attr_name}_#{locale_for_attr_name}?"
        end
      end

      def define_localized_attr_setter(attr_name)
        define_method "#{attr_name}=" do |val|
          send "#{attr_name}_#{locale_for_attr_name}=", val
        end
      end

      def define_localized_attr_finder(attr_name)
        define_singleton_method "find_by_#{attr_name}" do |val|
          send "find_by_#{attr_name}_#{locale_for_attr_name}", val
        end
      end

      def locale_for_attr_name
        I18n.locale.to_s.underscore
      end

      def locale_attr(attr_name)
        "#{attr_name}_#{I18n.locale.to_s.underscore}"
      end
    end

    include ClassMethods
  end
end
