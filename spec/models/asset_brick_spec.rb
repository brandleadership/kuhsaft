require 'spec_helper'

describe Kuhsaft::AssetBrick do

  let :asset_brick do
    Kuhsaft::AssetBrick.new
  end

  describe '#valid' do
    before do
      asset_brick.valid?
    end

    context 'without a #caption' do
      it 'has an error' do
        asset_brick.should have(1).error_on(:caption)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      asset_brick.should_not respond_to(:bricks)
    end
  end

  describe '.styles' do
    it 'returns the available link styles' do
      Kuhsaft::AssetBrick.styles.should == %w(pdf word excel button)
    end
  end

  describe '#to_style_class' do
    it 'includes the link style' do
      asset_brick.stub(:link_style).and_return('pdf')
      asset_brick.to_style_class.should == 'kuhsaft-asset-brick pdf'
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      asset_brick.user_can_add_childs?.should be_false
    end
  end
end
