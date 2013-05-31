require 'spec_helper'

describe Kuhsaft::TextBrick do
  let :text_brick do
    Kuhsaft::TextBrick.new
  end

  describe '#bricks' do
    it 'can not have childs' do
      text_brick.should_not respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      text_brick.user_can_add_childs?.should be_false
    end
  end

  describe '#collect_fulltext' do
    before do
      text_brick.text = '<div><b>foo</b> <b>bar</b></div>'
      text_brick.read_more_text = '<div><span>foo</span><span>bar</span></div>'
    end

    it 'sanitizes text and read_more_text' do
      text_brick.collect_fulltext.should == 'foo bar foobar'
    end
  end
end
