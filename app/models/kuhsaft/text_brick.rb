module Kuhsaft
  class TextBrick < Brick
    attr_accessible :text, :read_more_text

    before_save :strip_read_more_text

    def user_can_add_childs?
      false
    end

    def collect_fulltext
      [super, text, read_more_text].join(' ')
    end

    private

    # Clear read_more_text field if it just contains an empty p tag
    #
    # readctor.js injects an almost empty p-tag into empty form fields.
    # However, instead of being really empty, it currently contains the &#8203; (Zero width space)
    # Character.
    def strip_read_more_text
      read_more_text.clear if text_contains_funky_chars
    end

    def text_contains_funky_chars
      read_more_text && Digest::MD5.hexdigest(read_more_text) == "9ec94c03b98c5b356364006bf4e73dce"
    end
  end
end
