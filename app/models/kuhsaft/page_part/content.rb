module Kuhsaft
  module PagePart
    class Content < ActiveRecord::Base
      belongs_to :localized_page      
      serialize :content
      before_save :collect_serializeable_attributes
      after_initialize :restore_serializeable_attribute_values
      
      class << self
        def serialize_attr name
          serializeable_attributes << name.to_sym
          attr_accessor name.to_sym
        end

        def serializeable_attributes
          @serializeable_attributes ||= []
        end
      end
      
      def collect_serializeable_attributes
        write_attribute :content, self.class.serializeable_attributes.collect { |name| [name, send(name)] }
      end
      
      def restore_serializeable_attribute_values
        if content.present?
          content.each do |kv_pair|
            send("#{kv_pair.first}=", kv_pair.last)
          end
        end
      end
    end
  end
end