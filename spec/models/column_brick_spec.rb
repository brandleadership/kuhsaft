require 'spec_helper'

describe Kuhsaft::ColumnBrick, type: :model do

  let :column_brick do
    Kuhsaft::ColumnBrick.new
  end

  describe '#user_can_delete?' do
    it 'returns false' do
      expect(column_brick.user_can_delete?).to be_falsey
    end
  end

  describe '#user_can_save' do
    it 'returns false' do
      expect(column_brick.user_can_save?).to be_falsey
    end
  end

  describe '#renders_own_childs?' do
    it 'returns false' do
      expect(column_brick.renders_own_childs?).to be_falsey
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      expect(column_brick).to respond_to(:bricks)
    end
  end
end
