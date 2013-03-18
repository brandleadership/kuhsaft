require 'spec_helper'

describe Kuhsaft::TextBrick do

  let :text_brick do
    Kuhsaft::TextBrick.new
  end

  describe 'saving with empty read more text' do

    before :each do
      text_brick.text = 'foo'
      text_brick.read_more_text = '<p>\xE2\x80\x8B</p>'
      text_brick.brick_list_id = 1
    end

    it 'strips empty p tag from read more text' do
      # TODO: do this without stubbing.
      text_brick.stub(:text_contains_funky_chars).and_return(:true)
      text_brick.save
      text_brick.read_more_text.should be_empty
    end
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
end
