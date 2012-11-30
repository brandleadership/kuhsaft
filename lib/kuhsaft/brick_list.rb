module Kuhsaft
  module BrickList
    def self.included(base)
      def base.acts_as_brick_list
        self.has_many :bricks, :class_name => 'Kuhsaft::Brick', :dependent => :destroy, :as => :brick_list
      end
    end

    def to_brick_item_id
      "brick-item-#{id}-#{self.class.to_s.underscore.gsub('/', '_')}"
    end

    def to_brick_list_id
      "brick-list-#{id}-#{self.class.to_s.underscore.gsub('/', '_')}"
    end

    def user_can_add_childs?
      true
    end

    def user_can_change_persisted?
      true
    end

    def renders_own_childs?
      false
    end

  end
end
