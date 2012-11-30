module Kuhsaft
  class ColumnBrick < Brick
    include Kuhsaft::BrickList
    acts_as_brick_list

    def user_can_change_persisted?
      false
    end

    def renders_own_childs?
      false
    end

  end
end
