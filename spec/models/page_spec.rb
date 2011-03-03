require 'spec_helper'

describe Kuhsaft::Page do
  
  before :each do 
    @page = Factory.create :page
  end
  
  it 'should have many localized_pages' do
    @page.localized_pages.count.should >= 1
  end
  
  it 'should have child pages' do
    @page.childs << Factory.create(:page)
    @page.childs.count.should >= 1
  end
  
  it 'should be the root page' do
    @page.root?.should be(true)
  end
  
  it 'should have a parent page' do
    child = Factory.create(:page)
    @page.childs << child
    child.parent.id.should be(@page.id)
  end
  
  it 'should have a list of root pages' do
    Kuhsaft::Page.all.each { |p| p.destroy }
    root_page = Factory.create :page
    root_page.childs << Factory.create(:page)
    root_page.childs << Factory.create(:page)
    Kuhsaft::Page.root_pages.count.should >= 1
  end
  
  it 'should save the localized_page when saved' do
    @page.should_receive(:save_localized_page)
    @page.save
  end
  
  describe 'should delegate property' do
    it 'should have a localized_page to delegate to' do
      @page.localized_page.should be_a(Kuhsaft::LocalizedPage)
    end
    
    it 'should delegate the title to the localized_page' do
      @page.title = 'Hello'
      @page.localized_page.title.should == 'Hello'
    end
    
    it 'should delegate the slug to the localized_page' do
      @page.slug = 'my-slug'
      @page.localized_page.slug.should == 'my-slug'
    end
    
    it 'should delegate the keywords to the localized_page' do
      @page.keywords = 'my keywords are superb'
      @page.localized_page.keywords.should == 'my keywords are superb'
    end
    
    it 'should delegate the description to the localized_page' do
      @page.description = 'my description'
      @page.localized_page.description.should == 'my description'
    end
  end
end