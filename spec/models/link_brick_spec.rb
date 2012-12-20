require 'spec_helper'

describe Kuhsaft::LinkBrick do

  let :link_brick do
    Kuhsaft::LinkBrick.new
  end

  describe '#valid' do
    before do
      link_brick.valid?
    end

    context 'without a #href' do
      it 'has en error' do
        link_brick.should have(1).error_on(:href)
      end
    end

    context 'without a #caption' do
      it 'has an error' do
        link_brick.should have(1).error_on(:caption)
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      link_brick.should_not respond_to(:bricks)
    end
  end
end
