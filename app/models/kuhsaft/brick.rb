module Kuhsaft
  class Brick < ActiveRecord::Base
    include Kuhsaft::BrickList

    belongs_to :brick_list, :polymorphic => true, :touch => true

    scope :localized, -> { where(:locale => I18n.locale) }
    default_scope -> { order('position ASC').localized }

    serialize :display_styles, Array

    attr_accessible :locale,
                    :position,
                    :type,
                    :brick_list_id,
                    :brick_list_type,
                    :display_styles

    before_validation :set_position

    validates :locale,
              :position,
              :type,
              :brick_list_id,
              :brick_list_type,
              :presence => true

    after_initialize do
      self.position ||= has_siblings? ? brick_list.bricks.maximum(:position).to_i + 1 : 1
    end

    after_save do
      brick_list.collect_fulltext
      brick_list.save!
    end

    def to_edit_partial_path
      path = self.to_partial_path.split '/'
      path << 'edit'
      path.join '/'
    end

    def has_siblings?
      if brick_list
        brick_list.bricks.any?
      end
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

    def parents
      p = []
      parent = brick_list.presence

      while parent
        p << parent
        parent = parent.respond_to?(:brick_list) ? parent.brick_list : nil
      end
      p.reverse
    end

    def set_position
      self.position = if self.position.present?
        self.position
      elsif self.respond_to?(:brick_list) && self.brick_list.respond_to?(:bricks)
        brick_list.bricks.maximum(:position).to_i + 1
      else
        1
      end
    end

    def brick_list_type
      'Kuhsaft::Brick'
    end

    # Returns a css classname suitable for use in the frontend
    def to_style_class
      ([self.class.to_s.underscore.dasherize.gsub('/', '-')] + self.display_styles).join(' ')
    end

    # Returns a unique DOM id suitable for use in the frontend
    def to_style_id
      "#{self.class.to_s.underscore.dasherize.gsub('/', '-')}-#{id}"
    end

    # return a list of css classnames that can be applied to the brick
    def available_display_styles
      []
    end

    def backend_label(options = {})
      label = self.class.model_name.human
      if options[:parenthesis] == true
        "(#{label})"
      else
        label
      end
    end
  end
end
