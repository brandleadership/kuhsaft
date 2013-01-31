require 'spec_helper'

describe Kuhsaft::AccordionItemBrick do

  let :accordion_item_brick do
    Kuhsaft::AccordionItemBrick.new
  end

  describe '#valid' do
    before do
      accordion_item_brick.valid?
    end

    context 'without a #caption' do
      it 'has en error' do
        accordion_item_brick.should have(1).error_on(:caption)
      end
    end
  end

  describe '#user_can_delete?' do
    it 'returns true' do
      accordion_item_brick.user_can_delete?.should be_true
    end
  end

  describe '#renders_own_childs?' do
    it 'returns false' do
      accordion_item_brick.renders_own_childs?.should be_false
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      accordion_item_brick.should respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'includes the bootstrap classname' do
      accordion_item_brick.to_style_class.should == 'kuhsaft-accordion-item-brick accordion-group'
    end
  end
end
