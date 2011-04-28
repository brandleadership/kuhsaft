require 'spec_helper'

describe Kuhsaft::LocalizedPage do
  before :each do
    @localized_page = Factory.create(:localized_page)
  end
  
  it 'should have a symbolized locale' do
    @localized_page.locale.should be(:en)
  end
  
  it 'should be published' do
    @localized_page.published?.should be_true
  end
  
  it 'should have a fulltext field' do
    @localized_page.should respond_to(:fulltext)
  end
  
  it 'should not be published when set to false' do
    @localized_page.update_attribute :published, false
    @localized_page.published?.should be_false
  end
  
  it 'should not be published when set to 0' do
    @localized_page.update_attribute :published, 0
    @localized_page.published?.should be_false
  end
  
  it 'should belong to a page' do
    @localized_page.page.should be_a(Kuhsaft::Page)
  end
  
  it 'should create a slug when the slug is empty' do
    @localized_page.should_receive(:create_slug)
    @localized_page.save
  end
  
  it 'should generate the slug from the title' do
    @localized_page.slug.should eq(@localized_page.title.parameterize)
  end
  
  it 'should have page_parts' do
    @localized_page.should respond_to(:page_parts)
  end
  
  it 'should not generate the slug if the user has set it' do
    Factory.create(:localized_page, :slug => 'my-slug').slug.should == 'my-slug'
  end
  
  after :each do
    @localized_page.destroy
  end
  
  describe 'page_type' do
    it 'should have a page_type' do
      @localized_page.should respond_to(:page_type)
    end
    
    it 'should just generate the url when the page_type is empty' do
      page = Factory.create :page
      page.translation.url.should eq('en/english-title')
    end
    
    it 'should save the users url with a "REDIRECT" page_type' do
      page = Factory.create :page
      page.translation.page_type = Kuhsaft::PageType::REDIRECT
      page.translation.url = '/en/news'
      page.save
      page.translation.url.should eq('/en/news')
    end
    
    it 'should not use the slug in the url when the page_type is "NAVIGATION"' do
      page = Factory.create :page
      child_page = Factory.create :page
      page.childs << child_page
      page.translation.page_type = Kuhsaft::PageType::NAVIGATION
      page.save
      child_page.translation.url.should eq('en/english-title')
    end
  end
  
  describe 'validations' do
    before do
      @localized_page = Factory.create :localized_page
      @localized_page.title = nil
      @localized_page.slug = nil
    end
    
    it 'should have a title' do
      @localized_page.should have(1).error_on(:title)
    end
    
    it 'should have a slug' do
      @localized_page.should have(1).error_on(:slug)
    end
    
    after do
      @localized_page.destroy
    end
  end
  
  describe 'fulltext' do
    before do
      @page =  Factory.create :page
      @page.translation.keywords = 'key words'
      @page.translation.description = 'descrip tion'
      @page.translation.title = 'my title'
      @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la1')
      @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la2')
      @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la3')
      @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => nil)
      @page.save
    end
    
    it 'should collect the fulltext when saved' do
      @page.translation.should_receive(:collect_fulltext)
      @page.save
    end
    
    it 'should contain the title' do
      @page.fulltext.should include('my title')
    end
    
    it 'should contain the keywords' do
      @page.fulltext.should include('key words')
    end
    
    it 'should contain the description' do
      @page.fulltext.should include('descrip tion')
    end
    
    it 'should contain the page part content' do
      @page.fulltext.should include('oh la la')
    end
    
    it 'should convert all data to strings' do
      expect { @page.translation.collect_fulltext }.to_not raise_error
    end
  end
  
  describe 'search' do
    before do
      Factory.create :page
      Factory.create :page
      Factory.create :page
    end
    
    it 'should find any containing the search term' do
      Kuhsaft::LocalizedPage.search('hi').should have_at_least(0).items
    end
    
    it 'should find with "English Title"' do
      Kuhsaft::LocalizedPage.search('English Title').should have_at_least(1).item
    end
    
    it 'should only find results with the current locale' do
      Kuhsaft::LocalizedPage.search('English Title').should be_all { |p| p.locale == Kuhsaft::Page.current_translation_locale }
    end
    
    it 'should only find published results' do
      Kuhsaft::LocalizedPage.search('English Title').should be_all { |p| p.published? == true }
    end
  end
end