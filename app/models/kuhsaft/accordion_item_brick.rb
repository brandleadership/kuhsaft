module Kuhsaft
  class AccordionItemBrick < ColumnBrick
    validates :caption, :presence => true

    def user_can_delete?
      true
    end

    def to_style_class
      [super, 'accordion-group'].join(' ')
    end

    def user_can_save?
      true
    end

    def collect_fulltext
      [super, caption].join(' ')
    end
  end
end
