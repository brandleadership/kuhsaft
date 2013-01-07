module Kuhsaft
  class Brick < ActiveRecord::Base
    include Kuhsaft::BrickList

    belongs_to :brick_list, :polymorphic => true

    scope :localized, lambda { where(:locale => I18n.locale) }
    default_scope order('position ASC').localized

    attr_accessible :locale,
                    :position,
                    :type,
                    :brick_list_id,
                    :brick_list_type

    before_validation :set_locale
    before_validation :set_position
    before_validation :set_brick_list_type

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

    def to_edit_childs_partial_path
      path = self.to_partial_path.split '/'
      path << 'childs'
      path.join '/'
    end

    def fulltext
      raise NotImplementedError
    end

    def render_stacked?
      false
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

    def set_brick_list_type
      self.brick_list_type = self.brick_list_type.presence || 'Kuhsaft::Brick'
    end
  end
end
