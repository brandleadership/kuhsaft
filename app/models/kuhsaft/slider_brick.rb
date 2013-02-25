module Kuhsaft
  class SliderBrick < Brick
    include Kuhsaft::BrickList

    acts_as_brick_list

    def fulltext
    end

    def to_style_class
      [super, 'carousel', 'slide'].join(' ')
    end

    def allowed_brick_types
      %w(Kuhsaft::ImageBrick Kuhsaft::VideoBrick)
    end

  end
end

