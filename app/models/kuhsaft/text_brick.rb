module Kuhsaft
  class TextBrick < Brick
    attr_accessible :text, :read_more_text

    def user_can_add_childs?
      false
    end

    def collect_fulltext
      [super, text, read_more_text].join(' ')
    end
  end
end
