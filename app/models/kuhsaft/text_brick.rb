require 'htmlentities'

module Kuhsaft
  class TextBrick < Brick
    include ActionView::Helpers::SanitizeHelper
    HTML_ENTITIES = HTMLEntities.new

    attr_accessible :text, :read_more_text

    def user_can_add_childs?
      false
    end

    def collect_fulltext
      HTML_ENTITIES.decode(
        strip_tags([
          text,
          read_more_text
        ].compact.join(' ')).squish
      )
    end
  end
end
