require 'spec_helper'

describe Kuhsaft::SliderBrick do

  let :slider_brick do
    Kuhsaft::SliderBrick.new
  end

  describe '#bricks' do
    it 'can have childs' do
      slider_brick.should respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'includes the bootstrap styles' do
      slider_brick.to_style_class.should == 'kuhsaft-slider-brick carousel slide'
    end
  end
end
