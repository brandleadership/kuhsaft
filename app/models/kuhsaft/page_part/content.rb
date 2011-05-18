module Kuhsaft
  module PagePart
    class Content < ActiveRecord::Base
      include Kuhsaft::Orderable
      
      belongs_to :localized_page      
      serialize :content
      before_validation :downcase_tags
      acts_as_taggable
      
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
        
        def searchable_attr name
          name = name.to_sym
          searchable_attributes << name
        end
        
        def searchable_attributes
          @searchable_attributes ||= []
        end

        def serializeable_attributes
          @serializeable_attributes ||= []
        end
        
        def page_part_types
          descendants
        end
        
        def to_name
          I18n.translate self.to_s.underscore.gsub('/', '.').downcase
        end
      end
      
      def downcase_tags
        self.tags = self.tags.downcase unless self.tags.blank?
      end
      
      def edit_partial_path
        path = self.class.model_name.partial_path.split '/'
        path << "edit_#{path.pop}"
        path.join '/'
        #self.class.model_name.partial_path
      end
      
      def siblings
        self.localized_page.page_parts.where('id !=?', self.id)
      end
      
      def show_partial_path
        path = self.class.model_name.partial_path.split '/'
        path << "show_#{path.pop}"
        path.join '/'
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