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
        
        def page_part_types
          descendants
        end
        
        def class_for_key key
          key.split('.').map(&:camelize).join('::').constantize
        end
    
        def key_for_class klass
          klass.to_s.gsub('::', '.').underscore
        end
        
        def to_name
          self.to_s.split('::').last
        end
        
        def to_key
          key_for_class self
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
      
      private
      #
      # OMFG, OMFG!!! http://stackoverflow.com/questions/5178204/what-is-a-better-way-to-create-sti-model-instance
      #
      def atributes_protected_by_default
        super - [self.class.inheritance_column]
      end
    end
  end
end