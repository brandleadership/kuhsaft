module Kuhsaft
  class AccordionBrick < ColumnBrick
    attr_accessible :caption
    validates :caption, :presence => true

    # TODO: validate only accept AccordionItem as child

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
