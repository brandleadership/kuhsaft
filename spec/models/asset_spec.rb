require 'spec_helper'

describe Kuhsaft::Asset, type: :model do

  let :asset do
    create(:asset)
  end

  let :uploader do
    u = Kuhsaft::AssetUploader.new(asset, :file)
    u.store! File.open(Kuhsaft::Engine.root.join('spec/dummy/app/assets/images/spec-image.png'))
    u
  end

  before do
    Kuhsaft::AssetUploader.enable_processing = true
  end

  after do
    Kuhsaft::AssetUploader.enable_processing = false
  end

  it 'has a thumbnail' do
    expect(uploader).to respond_to(:thumb)
  end

  it 'makes the image readable only to the owner and not executable' do
    pending 'how and where do we ensure permissions?'
    expect(uploader).to have_permissions(0600)
  end

  describe '#file_type' do
    it 'has a file_type' do
      expect(asset).to respond_to(:file_type)
    end

    it 'is symbolized' do
      expect(asset.file_type).to be_a(Symbol)
    end
  end
end
