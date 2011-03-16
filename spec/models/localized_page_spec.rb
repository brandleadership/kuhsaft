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
  
  it 'should have a complete slug, consisting of it\'s parent pages slug' do
    Kuhsaft::Page.current_translation_locale = :en
    root_page = Factory.create(:page)
    child_page = Factory.create(:page)
    root_page.childs << child_page
    child_page.url.should == '/en/english-title/english-title'
  end
  
  describe 'validations' do
    it 'should have a title' do
      localized_page = Kuhsaft::LocalizedPage.new
      localized_page.save
      localized_page.should have(1).error_on(:title)
    end
    
    it 'should have a locale' do
      localized_page = Kuhsaft::LocalizedPage.new
      localized_page.save
      localized_page.should have(1).error_on(:locale)
    end
    
    it 'should have a slug' do
      localized_page = Kuhsaft::LocalizedPage.new
      localized_page.save
      localized_page.should have(1).error_on(:slug)
    end
  end
end