require 'spec_helper'

describe Kuhsaft::AnchorBrick do

  let :anchor_brick do
    Kuhsaft::AnchorBrick.new
  end

  describe '#bricks' do
    it 'can not have childs' do
      anchor_brick.should_not respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      anchor_brick.user_can_add_childs?.should be_false
    end
  end
end
