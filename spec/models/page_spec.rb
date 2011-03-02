require 'spec_helper'

describe Kuhsaft::Page do
  
  before :each do 
    @page = Factory.create :page
  end
  
  it 'should have many localized_pages' do
    @page.localized_pages.count.should be(1)
  end
  
  it 'should have child pages' do
    @page.childs << Factory.create(:page)
    @page.childs.count.should be(1)
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
    Kuhsaft::Page.root_pages.count.should be(1)
  end
end