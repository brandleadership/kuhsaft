require 'spec_helper'

describe Kuhsaft::Brick do

  describe '#fulltext' do
    it 'must be overriden' do
      expect { Kuhsaft::Brick.new }.to raise_error
    end
  end
end
