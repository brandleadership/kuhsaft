module Kuhsaft
  class AccordionBrick < ColumnBrick
    attr_accessible :caption
    validates :caption, :presence => true

    # TODO: validate only accept AccordionItem as child

    def user_can_change_persisted?
      true
    end
  end
end
