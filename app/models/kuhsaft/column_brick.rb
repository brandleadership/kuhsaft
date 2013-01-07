module Kuhsaft
  class ColumnBrick < Brick
    include Kuhsaft::BrickList
    acts_as_brick_list

    #
    # Users should not be able to delete this brick through the UI
    #
    def user_can_change_persisted?
      false
    end

    def renders_own_childs?
      false
    end

  end
end
