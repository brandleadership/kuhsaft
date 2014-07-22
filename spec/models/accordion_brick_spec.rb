require 'spec_helper'

describe Kuhsaft::AccordionBrick, type: :model do

  let :accordion_brick do
    Kuhsaft::AccordionBrick.new
  end

  describe '#user_can_delete?' do
    it 'returns true' do
      expect(accordion_brick.user_can_delete?).to be_truthy
    end
  end

  describe '#renders_own_childs?' do
    it 'returns false' do
      expect(accordion_brick.renders_own_childs?).to be_falsey
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      expect(accordion_brick).to respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'includes the bootstrap classname' do
      expect(accordion_brick.to_style_class).to eq('kuhsaft-accordion-brick accordion')
    end
  end

  describe '#allowed_brick_types' do
    it 'only allows AccordionItems' do
      expect(accordion_brick.allowed_brick_types).to eq(%w(Kuhsaft::AccordionItemBrick))
    end
  end
end
