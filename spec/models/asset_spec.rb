require 'spec_helper'

describe Kuhsaft::Asset do
  before do
    Kuhsaft::AssetUploader.enable_processing = true
    @asset = Kuhsaft::Asset.new
    @uploader = Kuhsaft::AssetUploader.new(@asset, :file)
    @uploader.store!(File.open(File.join(Kuhsaft::Engine.root, 'spec', 'dummy', 'public', 'images', 'spec-image.png')))
  end
  
  after do
    Kuhsaft::AssetUploader.enable_processing = false
  end
  
  it 'should scale down to fit into a 50x50 thumb' do
    @uploader.thumb.should have_dimensions(50, 50)
  end
  
  it "should make the image readable only to the owner and not executable" do
    pending 'how and where do we ensure permissions?'
    @uploader.should have_permissions(0600)
  end
end