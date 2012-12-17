require 'spec_helper'

describe Kuhsaft::TextBrick do
  describe '#render_stacked?' do
    it 'returns false' do
      Kuhsaft::TextBrick.new.render_stacked?.should be_false
    end

    context 'when nested inside a TwoColumnBrick' do
      it 'returns true' do
        page, two_col_brick, text_brick = mock_model(Kuhsaft::Page),
                                          mock_model(Kuhsaft::TwoColumnBrick),
                                          Kuhsaft::TextBrick.new
        text_brick.stub(:brick_list).and_return(two_col_brick)
        two_col_brick.stub(:brick_list).and_return(page)
        text_brick.render_stacked?.should be_true
      end
    end
  end
end
