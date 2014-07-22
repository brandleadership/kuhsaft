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
        expect(video_brick).to have(1).error_on(:any_source)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      expect(video_brick).not_to respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(video_brick.user_can_add_childs?).to be_false
    end
  end
end
