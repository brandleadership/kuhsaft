module Kuhsaft
  class SliderBrick < Brick
    include Kuhsaft::BrickList

    acts_as_brick_list

    def fulltext
    end

    def to_style_class
      [super, 'carousel', 'slide'].join(' ')
    end

  end
end

