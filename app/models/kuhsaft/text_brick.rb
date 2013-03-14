module Kuhsaft
  class TextBrick < Brick
    attr_accessible :text, :read_more_text

    before_save :strip_read_more_text

    def strip_read_more_text
      read_more_text.clear if Digest::MD5.hexdigest(read_more_text) == "9ec94c03b98c5b356364006bf4e73dce"
    end

    def user_can_add_childs?
      false
    end

    def collect_fulltext
      [super, text, read_more_text].join(' ')
    end
  end
end
