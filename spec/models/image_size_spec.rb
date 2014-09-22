require 'spec_helper'

describe Kuhsaft::ImageSize, type: :model do
  before do
    Kuhsaft::ImageSize.build_defaults!
  end

  describe '.build_defaults!' do
    it 'sets the default sizes' do
      expect(Kuhsaft::ImageSize.all).to eq([Kuhsaft::ImageSize.gallery_size,
                                            Kuhsaft::ImageSize.teaser_size])
    end
  end

  describe '.clear!' do
    before do
      Kuhsaft::ImageSize.clear!
    end

    it 'empties the list' do
      expect(Kuhsaft::ImageSize.all).to be_empty
    end
  end

  describe '.add' do
    it 'adds a new image size' do
      expect { Kuhsaft::ImageSize.add(:stuff, 200, 100) }.to change(Kuhsaft::ImageSize.all, :count).by(1)
    end
  end

  describe '.find_by_name' do
    it 'returns the size' do
      expect(Kuhsaft::ImageSize.find_by_name('gallery')).to eq(Kuhsaft::ImageSize.gallery_size)
    end
  end
end
