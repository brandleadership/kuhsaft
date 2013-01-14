module Kuhsaft
  class AccordionItemBrick < ColumnBrick
    attr_accessible :caption
    validates :caption, :presence => true

    def user_can_change_persisted?
      true
    end
  end
end
