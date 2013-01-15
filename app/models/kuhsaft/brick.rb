module Kuhsaft
  class Brick < ActiveRecord::Base
    include Kuhsaft::BrickList

    belongs_to :brick_list, :polymorphic => true, :touch => true

    scope :localized, lambda { where(:locale => I18n.locale) }
    default_scope order('position ASC').localized

    attr_accessible :locale,
                    :position,
                    :type,
                    :brick_list_id,
                    :brick_list_type

    before_validation :set_locale
    before_validation :set_position

    validates :locale,
              :position,
              :type,
              :brick_list_id,
              :brick_list_type,
              :presence => true

    def to_edit_partial_path
      path = self.to_partial_path.split '/'
      path << 'edit'
      path.join '/'
    end

    #
    # The child partial can contain your own implementation
    # of how the brick renders it's child in the edit form.
    # Returns the path to this partial.
    #
    def to_edit_childs_partial_path
      path = self.to_partial_path.split '/'
      path << 'childs'
      path.join '/'
    end

    #
    # Return relevant fulltext information for this brick (e.g: it's name, description etc ).
    # It will be stored in the related Page.
    # Implement how you see fit.
    #
    def fulltext
      raise NotImplementedError
    end

    #
    # return true: brick form labels/inputs render horizontally
    # return false: brick form labels/inputs render vertically
    # (see: http://twitter.github.com/bootstrap/base-css.html#forms)
    #
    def render_as_horizontal_form?
      true
    end

    def parents
      p = []
      parent = brick_list.presence

      while parent
        p << parent
        parent = parent.respond_to?(:brick_list) ? parent.brick_list : nil
      end
      p.reverse
    end

    def set_locale
      self.locale = self.locale.presence || I18n.locale
    end

    def set_position
      self.position = self.position.presence || 1
    end

    def brick_list_type
      'Kuhsaft::Brick'
    end

    # Returns a css classname suitable for use in the frontend
    def to_style_class
      self.class.to_s.underscore.dasherize.gsub('/', '-')
    end

    # Returns a unique DOM id suitable for use in the frontend
    def to_style_id
      "#{self.class.to_s.underscore.dasherize.gsub('/', '-')}-#{id}"
    end
  end
end
