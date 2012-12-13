module Kuhsaft
  class TwoColumnBrick < ColumnBrick

    before_create :add_columns

    attr_accessible :partitioning

    def user_can_add_childs?
      false
    end

    def user_can_change_persisted?
      true
    end

    def renders_own_childs?
      true
    end

    def partitioning
      super || 0
    end

    def self.partitionings
      [Partition.new('70/30', 0), Partition.new('50/50', 1), Partition.new('30/70', 2)]
    end

    private

    def add_columns
      bricks << Kuhsaft::ColumnBrick.new
      bricks << Kuhsaft::ColumnBrick.new
    end
  end
end
