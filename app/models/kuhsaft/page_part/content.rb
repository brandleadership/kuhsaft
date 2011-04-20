module Kuhsaft
  module PagePart
    class Content < ActiveRecord::Base
      belongs_to :localized_page      
      serialize :content
      
      class << self
        def serialize_attr name
          name = name.to_sym
          serializeable_attributes << name
          
          define_method name do
            self.content ||= {}
            self.content[name].presence
          end
          
          define_method "#{name}=" do |val|
            self.content_will_change!
            self.content ||= {}
            self.content[name] = val
          end
        end

        def serializeable_attributes
          @serializeable_attributes ||= []
        end
        
        def page_part_types
          descendants
        end
        
        def to_name
          self.to_s.split('::').last
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