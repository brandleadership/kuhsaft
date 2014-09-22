require 'spec_helper'

describe Kuhsaft::Cms::PagesHelper, type: :helper do
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

  describe '#hide_content_tab?' do
    it 'has a page without translations' do
      @page = create(:page, title: 'Page 1', slug: 'page1')
      I18n.with_locale :de do
        expect(helper.hide_content_tab?(@page)).to be_truthy
      end
    end

    it 'has a redirect page' do
      @page = create(:page, title: 'Page 1', slug: 'page1',
                            page_type: Kuhsaft::PageType::REDIRECT, redirect_url: 'en/references')
      expect(helper.hide_content_tab?(@page)).to be_truthy
    end

    it 'has a not saved page' do
      @page = Kuhsaft::Page.new
      expect(helper.hide_content_tab?(@page)).to be_truthy
    end
  end
end
