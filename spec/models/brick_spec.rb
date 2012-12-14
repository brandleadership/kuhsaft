require 'spec_helper'

describe Kuhsaft::Brick do

  describe '#fulltext' do
    it 'must be overriden' do
      expect { Kuhsaft::Brick.new }.to raise_error
    end
  end

  describe '#render_stacked?' do
    it 'returns false by default' do
      Kuhsaft::Brick.new.render_stacked?.should be_false
    end
  end

  describe '#parents' do
    it 'returns the chain of parents' do
      item1, item2, item3 = mock, mock, Kuhsaft::Brick.new
      item2.stub(:brick_list).and_return(item1)
      item3.stub(:brick_list).and_return(item2)
      item3.parents.should == [item1, item2]
    end
  end
end
