require 'spec_helper'

describe Kuhsaft::VideoBrick do

  let :video_brick do
    Kuhsaft::VideoBrick.new
  end

  describe '#valid' do
    before do
      video_brick.valid?
    end

    context 'without any video source' do
      it 'has en error' do
        video_brick.should have(1).error_on(:any_source)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      video_brick.should_not respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      video_brick.user_can_add_childs?.should be_false
    end
  end
end
