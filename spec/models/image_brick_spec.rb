require 'spec_helper'

describe Kuhsaft::ImageBrick do

  let :image_brick do
    Kuhsaft::ImageBrick.new
  end

  describe '#valid' do
    before do
      image_brick.valid?
    end

    context 'without an #image' do
      it 'has en error' do
        image_brick.should have(1).error_on(:image)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      image_brick.should_not respond_to(:bricks)
    end
  end
end
