require 'spec_helper'

describe Kuhsaft::AssetBrick, type: :model do

  let :asset_brick do
    Kuhsaft::AssetBrick.new
  end

  describe '#valid' do
    before do
      asset_brick.valid?
    end

    context 'without a #caption' do
      it 'has an error' do
        expect(asset_brick.errors[:caption].count).to eq(1)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      expect(asset_brick).not_to respond_to(:bricks)
    end
  end

  describe '.styles' do
    it 'returns the available link styles' do
      expect(Kuhsaft::AssetBrick.styles).to eq(%w(pdf word excel button))
    end
  end

  describe '#to_style_class' do
    it 'includes the link style' do
      allow(asset_brick).to receive(:link_style).and_return('pdf')
      expect(asset_brick.to_style_class).to eq('kuhsaft-asset-brick pdf')
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(asset_brick.user_can_add_childs?).to be_falsey
    end
  end
end
