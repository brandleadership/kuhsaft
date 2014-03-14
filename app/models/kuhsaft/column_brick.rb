module Kuhsaft
  class ColumnBrick < Brick
    include Kuhsaft::BrickList
    acts_as_brick_list

    #
    # Users should not be able to delete this brick through the UI
    #
    def user_can_delete?
      false
    end

    # No need to save
    def user_can_save?
      false
    end

    def renders_own_childs?
      false
    end
  end
end
