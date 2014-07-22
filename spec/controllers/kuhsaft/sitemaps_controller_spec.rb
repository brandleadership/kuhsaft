require 'spec_helper'

describe Kuhsaft::SitemapsController, type: :controller do
  describe '#index' do
    before do
      @page = FactoryGirl.create(:page)
    end

    it 'should be able to send a xml file' do
      get(:index,  use_route: :kuhsaft, format: 'xml')
    end
  end
end
