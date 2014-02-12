require 'spec_helper'
include SitemapsHelper

describe 'kuhsaft/sitemaps/index.xml.haml' do
  describe 'structure' do
    before :each do
      @page = FactoryGirl.create(:page, :page_type => Kuhsaft::PageType::CONTENT, :published => true, :fulltext_de => 'foobar')
      @pages = [@page]
      render
    end

    it "renders valid xml" do
      expect{ Hash.from_xml(rendered) }.not_to raise_error
    end

    it "renders the XML template" do
      expect(rendered).to include "<?xml version='1.0' encoding='utf-8' ?>"
    end

    it 'includes the loc tag content' do
      expect(rendered).to include "<loc>http://#{@request.host}/#{@page.url}</loc>"
    end

    it 'includes the lastmod tag content' do
      expect(rendered).to include "<lastmod>#{@page.created_at.utc}</lastmod>"
    end

    it 'includes the changefreq tag content' do
      expect(rendered).to include "<changefreq>monthly</changefreq>"
    end

    it 'includes the priority tag content' do
      expect(rendered).to include "<priority>0.5</priority>"
    end
  end

  describe 'count of records'do
    before :each do
      I18n.with_locale(:de) do
        @page    = FactoryGirl.create(:page, :published => true, title: 'Dummy Page 1 DE', slug: 'dummy-page-1', url: 'de/dummy-page-1')
        @page_de = FactoryGirl.create(:page, :published => true, title: 'German Page', slug: 'german-page', url: 'de/german-page')
      end

      I18n.with_locale(:en) do
        @page.update_attributes(title: 'Dummy Page 1 EN', slug: 'dummy-page-1', slug: 'dummy-page-1', url: 'en/dummy-page-1')
        @page_en = FactoryGirl.create(:page, :published => true, title: 'English Page', slug: 'english-page', url: 'de/english-page')
      end

      @pages = [@page, @page_de, @page_en]
      render
    end

    it 'has the same count of entry as pages are there' do
      response.body.should have_xpath("//url", :count => 4)
    end

    it 'has a record for the german url' do
      expect(rendered).to include "<loc>http://#{@request.host}/de/dummy-page-1</loc>"
    end

    it 'has a record for the english url' do
      locale = I18n.locale
      I18n.locale = :en
      expect(rendered).to include "<loc>http://#{@request.host}/en/dummy-page-1</loc>"
      I18n.locale = locale
    end
  end
end
