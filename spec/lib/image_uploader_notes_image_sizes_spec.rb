require 'spec_helper'

describe Kuhsaft::ImageUploaderNotesImageSizes do

  let :brick do
    Kuhsaft::ImageBrick.new
  end

  describe '#uploader_mounting' do
    it 'has a uploader mounted' do
      brick.class.ancestors.include?(CarrierWave::Mount::Extension).should be_true
    end
  end
end
