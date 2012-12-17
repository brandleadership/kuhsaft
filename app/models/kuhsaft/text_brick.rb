module Kuhsaft
  class TextBrick < Brick
    attr_accessible :text, :read_more_text

    def render_stacked?
      true if parents.map(&:class).include? Kuhsaft::TwoColumnBrick
    end
  end
end
