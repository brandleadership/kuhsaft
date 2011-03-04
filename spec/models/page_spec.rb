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
  
  it 'should increment it\'s position by 1' do
    page = Factory.create :page, :position => 100
    page.increment_position
    page.position.should == 101
  end
  
  it 'should decrement it\'s position by 1' do
    page = Factory.create :page, :position => 102
    page.decrement_position
    page.position.should == 101
  end
  
  it 'should find the position of a page' do
    page = Factory.create :page, :position => 20
    Kuhsaft::Page.position_of(page.id).should be(20)
  end
  
  it 'should find the predecing sibling' do
    page1 = Factory.create :page, :position => 1111
    page2 = Factory.create :page, :position => 1112
    page3 = Factory.create :page, :position => 1113
    page3.preceding_sibling.id.should == page2.id
  end
  
  it 'should find the succeeding sibling' do
    page1 = Factory.create :page, :position => 1211
    page2 = Factory.create :page, :position => 1212
    page3 = Factory.create :page, :position => 1213
    page1.succeeding_sibling.id.should == page2.id
  end
  
  it 'should reposition before a page' do
    page1 = Factory.create :page, :position => 1311
    page2 = Factory.create :page, :position => 1312
    
    page2.reposition page1.id
    page2.save
    page2.position.should == 1311
  end
  
  it 'should reposition before all siblings' do
    page1 = Factory.create :page, :position => 1411
    page2 = Factory.create :page, :position => 1412
    
    page2.reposition nil
    page2.save
    page2.position.should == 0
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