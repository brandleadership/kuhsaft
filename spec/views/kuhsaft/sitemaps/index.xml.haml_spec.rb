require 'spec_helper'
include SitemapsHelper

describe 'kuhsaft/sitemaps/index.xml.haml', :type => :view do
  describe 'structure' do
    before :each do
      @page = create(:page)
      @pages = [@page]
      render
    end

    it 'renders valid xml' do
      expect { Hash.from_xml(rendered) }.not_to raise_error
    end

    it 'renders the XML template' do
      expect(rendered).to include "<?xml version='1.0' encoding='utf-8' ?>"
    end

    it 'includes the loc tag content' do
      expect(rendered).to include "<loc>http://#{@request.host}/#{@page.url}</loc>"
    end

    it 'includes the lastmod tag content' do
      expect(rendered).to include "<lastmod>#{@page.created_at.utc}</lastmod>"
    end

    it 'includes the changefreq tag content' do
      expect(rendered).to include '<changefreq>monthly</changefreq>'
    end

    it 'includes the priority tag content' do
      expect(rendered).to include '<priority>0.5</priority>'
    end
  end

  describe 'count of records'do
    before do
      allow(I18n).to receive(:available_locales).and_return([:de, :en])

      I18n.with_locale(:de) do
        @page    = create(:page, title: 'Dummy Page 1 DE')
        @page_de = create(:page, title: 'German Page')
      end

      I18n.with_locale(:en) do
        @page.update_attributes(title: 'Dummy Page 1 EN')
        @page_en = create(:page, title: 'English Page')
      end

      @pages = [@page, @page_de, @page_en]
      render
    end

    it 'has the same count of entry as pages are there' do
      expect(response.body).to have_xpath('//url', count: 4)
    end

    it 'has a record for the german url' do
      expect(rendered).to include "<loc>http://#{@request.host}/de/dummy-page-1-de</loc>"
    end

    it 'has a record for the english url' do
      expect(rendered).to include "<loc>http://#{@request.host}/en/dummy-page-1-en</loc>"
    end
  end
end
