require 'spec_helper'

describe Kuhsaft::ImageSize do
  describe '.all' do
    it 'returns the default sizes' do
      Kuhsaft::ImageSize.all.should == [Kuhsaft::ImageSize.gallery_size,
                                        Kuhsaft::ImageSize.teaser_size]
    end
  end
end
