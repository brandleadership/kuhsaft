require 'spec_helper'

describe Kuhsaft::Asset do
  before do
    Kuhsaft::AssetUploader.enable_processing = true
    @asset = FactoryGirl(:asset)
    @uploader = Kuhsaft::AssetUploader.new(@asset, :file)
    @uploader.store!(File.open(File.join(Kuhsaft::Engine.root, 'spec', 'dummy', 'app', 'assets', 'images', 'spec-image.png')))
  end

  after do
    Kuhsaft::AssetUploader.enable_processing = false
  end

  it 'should have a thumbnail' do
    @uploader.should respond_to(:thumb)
  end

  it "should make the image readable only to the owner and not executable" do
    pending 'how and where do we ensure permissions?'
    @uploader.should have_permissions(0600)
  end

  describe '#file_type' do
    it 'should have a file_type' do
      @asset.should respond_to(:file_type)
    end

    it 'should be symbolized' do
      @asset.file_type.should be_a(Symbol)
    end
  end

  describe '#name' do
    it 'should have a name' do
      @asset.should respond_to(:name)
    end
  end
end
