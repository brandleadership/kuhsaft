require 'spec_helper'

describe Kuhsaft::LinkBrick, type: :model do

  let :link_brick do
    Kuhsaft::LinkBrick.new
  end

  describe '#valid' do
    before do
      link_brick.valid?
    end

    context 'without a #href' do
      it 'has en error' do
        expect(link_brick.errors[:href].count).to eq(1)
      end
    end

    context 'without a #caption' do
      it 'has an error' do
        expect(link_brick.errors[:caption].count).to eq(1)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      expect(link_brick).not_to respond_to(:bricks)
    end
  end

  describe '.styles' do
    it 'returns the available link styles' do
      expect(Kuhsaft::LinkBrick.styles).to eq(%w(pdf word excel button external))
    end
  end

  describe '#to_style_class' do
    it 'includes the link style' do
      allow(link_brick).to receive(:link_style).and_return('pdf')
      expect(link_brick.to_style_class).to eq('kuhsaft-link-brick pdf')
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(link_brick.user_can_add_childs?).to be_falsey
    end
  end
end
