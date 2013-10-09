require 'spec_helper'

describe Kuhsaft::ImageUploaderNotesImageSizes do

  class TestBrick < Kuhsaft::Brick
    include Kuhsaft::ImageUploaderNotesImageSizes
  end

  let :brick do
    TestBrick.new
  end

  describe '#uploader_mounting' do
    it 'has a uploader mounted' do
      brick.class.ancestors.include?(CarrierWave::Mount::Extension).should be_true
    end
  end

  describe '#resize_image_if_size_changed' do
    it 'recreates versions' do
    end

    it 'does not recreate versions' do
    end
  end
end
