require 'spec_helper'

describe Kuhsaft::AccordionBrick do

  let :accordion_brick do
    Kuhsaft::AccordionBrick.new
  end

  describe '#user_can_change_persisted?' do
    it 'returns true' do
      accordion_brick.user_can_change_persisted?.should be_true
    end
  end

  describe '#renders_own_childs?' do
    it 'returns false' do
      accordion_brick.renders_own_childs?.should be_false
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      accordion_brick.should respond_to(:bricks)
    end
  end
end
