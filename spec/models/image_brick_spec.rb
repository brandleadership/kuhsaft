require 'spec_helper'

describe Kuhsaft::ImageBrick, type: :model do

  let :image_brick do
    Kuhsaft::ImageBrick.new
  end

  describe '#valid' do
    before do
      image_brick.valid?
    end

    context 'without an #image' do
      it 'has en error' do
        expect(image_brick.errors[:image].size).to eq(1)
      end
    end
  end

  describe '#save' do
    context 'when changing the image size' do
      it 'regenerates the image version' do
        allow(image_brick).to receive(:image_size_changed?).and_return(true)
        allow(image_brick).to receive(:image_present?).and_return(true)
        expect(image_brick.image).to receive(:recreate_versions!)
        image_brick.resize_image_if_size_changed
      end
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      expect(image_brick).not_to respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(image_brick.user_can_add_childs?).to be_falsey
    end
  end

  describe '#uploader?' do
    it 'returns true' do
      expect(image_brick.uploader?).to be_truthy
    end
  end
end
