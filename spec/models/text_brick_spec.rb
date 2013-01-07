require 'spec_helper'

describe Kuhsaft::TextBrick do

  let :text_brick do
    Kuhsaft::TextBrick.new
  end

  describe '#render_as_horizontal_form?' do
    it 'returns true' do
      text_brick.render_as_horizontal_form?.should be_true
    end

    context 'when nested inside a TwoColumnBrick' do
      it 'returns false' do
        page, two_col_brick, text_brick = mock_model(Kuhsaft::Page),
                                          mock_model(Kuhsaft::TwoColumnBrick),
                                          Kuhsaft::TextBrick.new
        text_brick.stub(:brick_list).and_return(two_col_brick)
        two_col_brick.stub(:brick_list).and_return(page)
        text_brick.render_as_horizontal_form?.should be_false
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      text_brick.should_not respond_to(:bricks)
    end
  end
end
