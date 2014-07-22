require 'spec_helper'
require 'rspec/active_model/mocks'

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
        result = [mock_model(Kuhsaft::Brick, collect_fulltext: 'hallo')]
        allow(brick).to receive_message_chain(:bricks, :localized).and_return(result)
        expect(brick.collect_fulltext).to eq('hallo')
      end
    end

    context 'with bricks without content' do
      it 'returns a string' do
        allow(brick).to receive_message_chain(:bricks, :localized).and_return([])
        expect(brick.collect_fulltext).to eq('')
      end
    end

    context 'without bricks' do
      it 'returns a string' do
        expect(brick.collect_fulltext).to eq('')
      end

      it 'does not fail' do
        expect { brick.collect_fulltext }.to_not raise_error
      end
    end
  end

  describe '#allowed_brick_types' do
    it 'returns an array of possible classes as strings' do
      expect(brick.allowed_brick_types).to be_a(Array)
    end
  end

  describe '#brick_types' do
    it 'returns a Kuhsaft::BrickTypeFilter' do
      expect(brick.brick_types).to be_a(Kuhsaft::BrickTypeFilter)
    end
  end
end
