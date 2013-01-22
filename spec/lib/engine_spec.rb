require 'spec_helper'

describe Kuhsaft::Engine do

  describe '.configure' do

    describe '.image_sizes' do
      it 'delegates .clear to ImageSize' do
        Kuhsaft::ImageSize.should_receive(:clear!)
        Kuhsaft::Engine.configure do
          config.image_sizes.clear!
        end
      end

      it 'delegates .add to ImageSize' do
        Kuhsaft::ImageSize.should_receive(:add).with(:something, 100, 200)
        Kuhsaft::Engine.configure do
          config.image_sizes.add(:something, 100, 200)
        end
      end
    end

  end

end
