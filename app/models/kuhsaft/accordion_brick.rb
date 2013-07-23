module Kuhsaft
  class AccordionBrick < ColumnBrick
    def user_can_delete?
      true
    end

    def to_style_class
      [super, 'accordion'].join(' ')
    end

    def allowed_brick_types
      %w(Kuhsaft::AccordionItemBrick)
    end
  end
end
