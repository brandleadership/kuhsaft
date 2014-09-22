require 'spec_helper'

describe Kuhsaft::SliderBrick, type: :model do

  let :slider_brick do
    Kuhsaft::SliderBrick.new
  end

  describe '#bricks' do
    it 'can have childs' do
      expect(slider_brick).to respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'includes the bootstrap styles' do
      expect(slider_brick.to_style_class).to eq('kuhsaft-slider-brick carousel slide')
    end
  end

  describe '#allowed_brick_types' do
    it 'only allows ImageBricks and VideoBricks' do
      expect(slider_brick.allowed_brick_types).to eq(%w(Kuhsaft::ImageBrick Kuhsaft::VideoBrick))
    end
  end
end
