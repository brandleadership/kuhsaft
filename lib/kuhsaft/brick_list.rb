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

    #
    # See TwoColumnBrick as an example, which can only have to ColumBricks
    # and the User should not be able to add more
    #
    def user_can_add_childs?
      true
    end

    #
    # return true if the user should be able to delete the brick through the UI.
    # return false if not.
    # See ColumnBrick, which should not be deleted inside the TwoColumnBrick
    #
    def user_can_change_persisted?
      true
    end

    #
    # When true, the brick must implement the rendering of its childs by itself
    # by using the _childs partial
    # When false, the default BrickList rendering is used
    # See _brick_item partial
    #
    def renders_own_childs?
      false
    end

    #
    # Return relevant fulltext information for this brick (e.g: it's name, description etc ).
    # It will be stored in the related Page.
    # Implement how you see fit.
    #
    def collect_fulltext
      if respond_to?(:bricks)
        bricks.localized.inject('') do |text, brick|
          text << brick.collect_fulltext
          text
        end
      else
        ''
      end
    end

  end
end
