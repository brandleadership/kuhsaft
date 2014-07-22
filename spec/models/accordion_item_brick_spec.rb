require 'spec_helper'

describe Kuhsaft::AccordionItemBrick, type: :model do

  let :accordion_item_brick do
    Kuhsaft::AccordionItemBrick.new
  end

  describe '#valid' do
    before do
      accordion_item_brick.valid?
    end

    context 'without a #caption' do
      it 'has en error' do
        expect(accordion_item_brick.errors[:caption].count).to eq(1)
      end
    end
  end

  describe '#user_can_delete?' do
    it 'returns true' do
      expect(accordion_item_brick.user_can_delete?).to be_truthy
    end
  end

  describe '#user_can_save' do
    it 'returns true' do
      expect(accordion_item_brick.user_can_save?).to eq(true)
    end
  end

  describe '#renders_own_childs?' do
    it 'returns false' do
      expect(accordion_item_brick.renders_own_childs?).to be_falsey
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      expect(accordion_item_brick).to respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'includes the bootstrap classname' do
      expect(accordion_item_brick.to_style_class).to eq('kuhsaft-accordion-item-brick accordion-group')
    end
  end
end
