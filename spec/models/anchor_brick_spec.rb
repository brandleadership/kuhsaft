require 'spec_helper'

describe Kuhsaft::AnchorBrick, type: :model do

  let :anchor_brick do
    Kuhsaft::AnchorBrick.new(caption: 'test-anchor')
  end

  describe '#bricks' do
    it 'can not have childs' do
      expect(anchor_brick).not_to respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(anchor_brick.user_can_add_childs?).to be_falsey
    end
  end

  describe '#to_id' do
    it 'returns a parameterized id' do
      expect(anchor_brick.to_id).to eq('anchor-test-anchor')
    end
  end
end
