require_relative '../../../lib/kuhsaft/brick_list'

module Kuhsaft
  class Brick < ActiveRecord::Base
    include Kuhsaft::BrickList

    belongs_to :brick_list, polymorphic: true, touch: true

    scope :localized, -> { where(locale: I18n.locale) }
    default_scope { order('position ASC').localized }

    serialize :display_styles, Array

    before_validation :set_position

    validates :locale,
              :position,
              :type,
              :brick_list_id,
              :brick_list_type,
              presence: true

    validates :template_name,
              :type,
              :locale,
              :caption,
              :link_style,
              :image_size,
              :video,
              :alt_text,
              length: { maximum: 255 }

    after_initialize do
      self.position ||= has_siblings? ? brick_list.bricks.maximum(:position).to_i + 1 : 1
    end

    after_save do
      # TODO: replace callback with fulltext row on each
      # searchable model
      if brick_list
        brick_list.update_fulltext
        brick_list.save!
      end
    end

    # TODO: yes. temporary workaround. see above
    def update_fulltext
      if brick_list.is_a? Page
        brick_list.update_fulltext
      else
        brick_list.brick_list.update_fulltext
      end
    end

    def to_edit_partial_path
      path = to_partial_path.split '/'
      path << 'edit'
      path.join '/'
    end

    def has_siblings?
      brick_list.present? && brick_list.bricks.any?
    end

    #
    # The child partial can contain your own implementation
    # of how the brick renders it's child in the edit form.
    # Returns the path to this partial.
    #
    def to_edit_childs_partial_path
      path = to_partial_path.split '/'
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
                      elsif self.respond_to?(:brick_list) && brick_list.respond_to?(:bricks)
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
      ([self.class.to_s.underscore.dasherize.gsub('/', '-')] + display_styles).join(' ')
    end

    # Returns a unique DOM id suitable for use in the frontend
    def to_style_id
      "#{self.class.to_s.underscore.dasherize.gsub('/', '-')}-#{id}"
    end

    # return a list of css classnames that can be applied to the brick
    def available_display_styles
      []
    end

    def translated_available_display_styles
      available_display_styles.map do |style|
        [I18n.t("#{self.class.to_s.demodulize.underscore}.display_styles.#{style}"), style]
      end
    end

    def backend_label(options = {})
      label = self.class.model_name.human
      if options[:parenthesis] == true
        "(#{label})"
      else
        label
      end
    end

    def partial_digest(name)
      ActionView::Digestor.digest(name, 'haml',  ApplicationController.new.lookup_context, partial: true)
    end

    def cache_key
      super +  partial_digest(to_partial_path)
    end
  end
end
