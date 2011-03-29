require 'spec_helper'

describe Kuhsaft::LocalizedPage do
  
  before :each do
    @localized_page = Factory.build :localized_page
  end
  
  it 'should have a symbolized locale' do
    @localized_page.locale.should be(:en)
  end
  
  it 'should be published' do
    Factory.create(:localized_page).published?.should be_true
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
    Factory.create(:localized_page).slug.should == @localized_page.title.parameterize
  end
  
  it 'should not generate the slug if the user has set it' do
    Factory.create(:localized_page, :slug => 'my-slug').slug.should == 'my-slug'
  end
  
  it 'should have pageparts' do
    Factory.create(:localized_page).page_parts.count.should be(1)
  end
  
  it 'should delegate childs to it\'s page' do
    @localized_page.childs.should == @localized_page.page.childs
  end
  
  describe 'validations' do
    
    before :each do
      @page = Factory.create :page
      @page.title = nil
      @page.slug = nil
    end
    
    it 'should have a title' do
      @page.translation.should have(1).error_on(:title)
    end
    
    it 'should have a slug' do
      @page.translation.should have(1).error_on(:slug)
    end
  end
end