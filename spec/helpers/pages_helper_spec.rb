require 'spec_helper'

describe PagesHelper do
  before do
    @page = FactoryGirl.create :page
  end

  after do
    destroy_all_pages
  end

  describe '#asset_for' do
    it 'should return the asset with the given id' do
      asset = FactoryGirl.create :asset
      asset_for(asset.id).should eq(asset)
    end
  end

  describe '#render_markdown' do
    it 'should parse markdown and convert it to html' do
      render_markdown('# hi').should eq("<h1>hi</h1>\n")
    end
  end

  describe '#navigation_for' do
    before do
      @page = FactoryGirl.create :page
      @page.childs << FactoryGirl.create(:page)
      @page.childs << FactoryGirl.create(:page)
      @page.save
    end

    it 'should return a list of pages' do
      navigation_for(@page.id).should have_at_least(2).pages
    end

    it 'should yield a list of pages if there is more than 1' do
      navigation_for(@page.id) { |pages| @yielded_pages = pages }
      @yielded_pages.should respond_to(:each) # don't be explicity about AR:Relation
    end

    it 'should not yield if there are not pages' do
      navigation_for(9999) { |pages| @yielded_pages = pages }
      @yielded_pages.should be_nil
    end

    it 'should accept options instead of an id' do
      page1, page2, page3 = create_page_tree
      page1.translation.page_type = Kuhsaft::PageType::NAVIGATION
      page1.translation.slug = 'test'
      page1.save
      navigation_for(:slug => 'test').should have(1).item
    end
  end

  describe '#homepage' do
    before do
      page1, page2, page3 = create_page_tree
      page1.translation.page_type = page2.translation.page_type = Kuhsaft::PageType::NAVIGATION
      page1.save
      page2.save
    end

    it 'should return the first page in the page hierarchy' do
      homepage.should be_a(Kuhsaft::Page)
    end
  end

  describe '#current_page_path' do
    it 'should return the path for the current page' do
      @page.localized_pages.create :locale => :de, :title => 'seite1'
      helper.current_page_path(:de).should eq('/de/seite1')
    end
  end

  describe '#active_page_class' do
    it '#active_page_class should return :active' do
      helper.stub!(:params).and_return :url => @page.url
      helper.active_page_class(@page).should be(:active)
    end
  end

  describe '#page_for_level' do
    before do
      destroy_all_pages
      @page1, @page2, @page3 = create_page_tree
      helper.stub!(:params).and_return :url => @page3.url
    end
    it 'should return the page for the 1. level' do
      helper.page_for_level(1).should eq(@page1)
    end

    it 'should return the page for the 2. level' do
      helper.page_for_level(2).should eq(@page2)
    end

    it 'should return the page for the 3. level' do
      helper.page_for_level(3).should eq(@page3)
    end

    it 'should yield the page to the given block' do
      helper.page_for_level(1) { |p| @yielded_page = p }
      @yielded_page.should eq(@page1)
    end
  end

  describe '#current_page' do
    it '#current_page should return the current page' do
      helper.stub!(:params).and_return :url => '/de/seite1'
      helper.current_page.should eq(@page)
    end

    it 'should yield the current_page to the given block' do
      helper.stub!(:params).and_return :url => 'en/english-title'
      helper.current_page { |page| @yielded_page = page }
      @yielded_page.should be_instance_of(Kuhsaft::Page)
    end
  end
end
