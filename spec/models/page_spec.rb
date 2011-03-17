require 'spec_helper'

describe Kuhsaft::Page do
  
  before do
    Kuhsaft::Page.translation_locales = ['en', 'de']
    Kuhsaft::Page.current_translation_locale = :en
  end
  
  before :each do 
    Kuhsaft::Page.all.each { |p| p.destroy }
    @page = Factory.create :page
  end
  
  it 'should have many localized_pages' do
    @page.localized_pages.count.should >= 1
  end
  
  it 'should have child pages' do
    p = Factory.create(:page)
    @page.childs << p
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
    root_page = Factory.create :page
    root_page.childs << Factory.create(:page)
    root_page.childs << Factory.create(:page)
    Kuhsaft::Page.root_pages.count.should >= 1
  end
  
  it 'should increment it\'s position by 1' do
    page = Factory.create :page
    position = page.position
    page.increment_position
    page.position.should == (position + 1)
  end
  
  it 'should decrement it\'s position by 1' do
    page = Factory.create :page
    position = page.position
    page.decrement_position
    page.position.should == (position - 1)
  end
  
  it 'should find the position of a page' do
    page = Factory.create :page
    position = page.position
    Kuhsaft::Page.position_of(page.id).should == position
  end
  
  it 'should find the predecing sibling' do
    page1 = Factory.create :page
    page2 = Factory.create :page
    page3 = Factory.create :page
    page3.preceding_sibling.id.should == page2.id
  end
  
  it 'should find the succeeding sibling' do
    page1 = Factory.create :page
    page2 = Factory.create :page
    page3 = Factory.create :page
    page2.succeeding_sibling.id.should == page3.id
  end
  
  it 'should reposition before a page' do
    page1 = Factory.create :page
    page2 = Factory.create :page
    page3 = Factory.create :page
    page3.reposition page1.id
    page3.preceding_sibling.id.should == page1.id
  end
  
  it 'should reposition before all siblings' do
    page1 = Factory.create :page
    page2 = Factory.create :page
    page2.reposition nil
    page2.position.should == 1
  end
  
  it 'should save the translation when saved' do
    @page.translation.title = 'some localized title'
    @page.should_receive(:save_translation)
    @page.save
  end
  
  it 'should have an url when saved' do
    page = Factory.create :page
    page.url.should == 'en/english-title'
  end
  
  it 'should have a link' do
    page = Factory.create :page
    page.link.should == '/en/english-title'
  end
  
  it 'should include the parents slug in its url' do
    page = Factory.create :page
    child = Factory.create :page
    page.childs << child
    page.save
    child.url.should == 'en/english-title/english-title'
  end
  
  it 'should return the link of its first child when its empty' do
    page = Factory.create :page
    child = Factory.create :page
    page.childs << child
    page.body = nil
    page.save
    page.link.should == child.link
  end
  
  it 'should find its translated content by url' do
    Kuhsaft::Page.all.each { |p| p.destroy }
    Kuhsaft::LocalizedPage.all.each{ |p| p.destroy }
    page = Factory.create(:page)
    Kuhsaft::Page.find_by_url(page.url).id.should == page.id
  end
  
  it 'should provide an array of translation locales' do
    Kuhsaft::Page.translation_locales.should be_a(Array)
  end
  
  it 'should have :en as minimal translation locale' do
    Kuhsaft::Page.translation_locales.include?(:en).should be_true
  end
  
  it 'should have the current translation locale' do
    Kuhsaft::Page.current_translation_locale = 'de'
    Kuhsaft::Page.current_translation_locale.should be(:de)
  end
  
  it 'should only contain symbolized locales' do
    Kuhsaft::Page.translation_locales = ['de']
    Kuhsaft::Page.translation_locales.first.should be(:de)
  end
  
  describe 'should delegate property' do
    it 'should have a localized_page to delegate to' do
      @page.translation.should be_a(Kuhsaft::LocalizedPage)
    end
    
    it 'should delegate the title to the translation' do
      @page.title = 'Hello'
      @page.translation.title.should == 'Hello'
    end
    
    it 'should delegate the slug to the translation' do
      @page.slug = 'my-slug'
      @page.translation.slug.should == 'my-slug'
    end
    
    it 'should delegate the url to the translation' do
      @page.url.should == @page.translation.url
    end
    
    it 'should delegate the keywords to the translation' do
      @page.keywords = 'my keywords are superb'
      @page.translation.keywords.should == 'my keywords are superb'
    end
    
    it 'should delegate the description to the translation' do
      @page.description = 'my description'
      @page.translation.description.should == 'my description'
    end
    
    it 'should delegate the locale to the translation' do
      @page.locale = 'de'
      @page.translation.locale.should == :de
    end
  end
end