module Kuhsaft
  class TextBrick < Brick
    attr_accessible :text, :read_more_text

    def render_as_horizontal_form?
      true unless parents.map(&:class).include? Kuhsaft::TwoColumnBrick
    end

    def collect_fulltext
      [super, text, read_more_text].join(' ')
    end
  end
end
