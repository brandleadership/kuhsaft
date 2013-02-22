require 'spec_helper'

describe Kuhsaft::BrickList do

  class TestBrick
    include Kuhsaft::BrickList
  end

  let :brick do
    TestBrick.new
  end

  describe '#collect_fulltext' do
    context 'with bricks' do
      it 'collects its childs fulltext' do
        brick.stub_chain(:bricks, :localized).and_return([mock_model(Kuhsaft::Brick, :collect_fulltext => 'hallo')])
        brick.collect_fulltext.should == 'hallo'
      end
    end

    context 'with bricks without content' do
      it 'returns a string' do
        brick.stub_chain(:bricks, :localized).and_return([])
        brick.collect_fulltext.should == ''
      end
    end

    context 'without bricks' do
      it 'returns a string' do
        brick.collect_fulltext.should == ''
      end

      it 'does not fail' do
        expect { brick.collect_fulltext }.to_not raise_error
      end
    end
  end

  describe '#allowed_brick_types' do
    it 'returns an array of possible classes as strings' do
      brick.allowed_brick_types.should be_a(Array)
    end
  end

  describe '#brick_types' do
    it 'returns a Kuhsaft::BrickTypeFilter' do
      brick.brick_types.should be_a(Kuhsaft::BrickTypeFilter)
    end
  end
end
