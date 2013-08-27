require 'spec_helper'

describe Kuhsaft::Cms::PagesHelper do
  describe '#content_tab_active' do
    it 'returns active when page has a title and no errors' do
      @page = create(:page, title: 'Page 1', slug: 'page1')
      expect(helper.content_tab_active(@page)).to be(:active)
    end

    it 'returns nil when page has no translation' do
      @page = create(:page, title: 'Page 1', slug: 'page1')
      I18n.with_locale :de do
        expect(helper.content_tab_active(@page)).to be_nil
      end
    end
  end

  describe '#metadata_tab_active' do
    it 'returns active when page is not translated' do
      @page = create(:page, title: 'Page 1', slug: 'page1')
      I18n.with_locale :de do
        expect(helper.metadata_tab_active(@page)).to be(:active)
      end
    end
  end
end
