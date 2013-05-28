module Kuhsaft
  class TextBrick < Brick
    attr_accessible :text, :read_more_text

    def user_can_add_childs?
      false
    end

    def collect_fulltext
      ActionView::Base.full_sanitizer.sanitize([
        super,
        text,
        read_more_text
      ].compact.join(' ').strip.gsub(/ +/, ' '))
    end
  end
end
