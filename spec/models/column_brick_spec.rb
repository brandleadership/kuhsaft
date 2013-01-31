require 'spec_helper'

describe Kuhsaft::ColumnBrick do

  let :column_brick do
    Kuhsaft::ColumnBrick.new
  end

  describe '#user_can_delete?' do
    it 'returns false' do
      column_brick.user_can_delete?.should be_false
    end
  end

  describe '#renders_own_childs?' do
    it 'returns false' do
      column_brick.renders_own_childs?.should be_false
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      column_brick.should respond_to(:bricks)
    end
  end
end
