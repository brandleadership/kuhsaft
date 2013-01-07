require 'spec_helper'

describe Kuhsaft::Cms::Admin do

  let :admin do
    Kuhsaft::Cms::Admin.new
  end

  describe '#admin?' do
    it 'is true and the default' do
      admin.admin?.should be_true
    end
  end

  describe '#editor?' do
    it 'is false' do
      admin.editor?.should be_false
    end
  end

  describe '#author?' do
    it 'is false' do
      admin.author?.should be_false
    end
  end
end
