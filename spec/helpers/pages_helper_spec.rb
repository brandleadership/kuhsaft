require 'spec_helper'

describe PagesHelper do
  before do
    @page = Factory.create :page
  end

  after do
    destroy_all_pages
  end

  it '#asset_for should return the asset with the given id' do
    asset = Factory.create :asset
    asset_for(asset.id).should eq(asset)
  end

  it '#navigation_for should return a list of pages' do
    @page.childs << Factory.create(:page)
    @page.childs << Factory.create(:page)
    @page.save
    navigation_for(@page.id).should have_at_least(2).pages
  end

  it '#current_page_path should return the german path for the current page' do
    @page.localized_pages.create :locale => :de, :title => 'seite1'
    helper.current_page_path(:de).should eq('/de/seite1')
  end

  it '#active_page_class should return "active"' do
    helper.stub!(:params).and_return :url => 'en/english-title'
    helper.active_page_class(@page).should eq('active')
  end
  
  it '#current_page should return the current page' do
    helper.stub!(:params).and_return :url => '/de/seite1'
    helper.current_page.should eq(@page)
  end

  describe '#page_for_level' do
    it 'should return the page for the 1. level of en/english-title/english-title/english-title' do
      destroy_all_pages
      page1, page2, page3 = create_page_tree
      helper.stub!(:params).and_return :url => 'en/english-title/english-title/english-title'
      helper.page_for_level(1).should eq(page1)
    end
    
    it 'should return the page for the 2. level of en/english-title/english-title/english-title' do
      page1, page2, page3 = create_page_tree
      helper.stub!(:params).and_return :url => 'en/english-title/english-title/english-title'
      helper.page_for_level(2).should eq(page2)
    end
    
    it 'should return the page for the 3. level of en/english-title/english-title/english-title' do
      page1, page2, page3 = create_page_tree
      helper.stub!(:params).and_return :url => 'en/english-title/english-title/english-title'
      helper.page_for_level(3).should eq(page3)
    end
  end
end