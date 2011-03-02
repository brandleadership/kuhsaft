require 'spec_helper'

describe Kuhsaft::LocalizedPage do
  
  before :each do
    @localized_page = Factory.build :localized_page
  end
  
  it 'should have a symbolized locale' do
    @localized_page.locale.should be(:de)
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
  
  it 'should have pageparts' do
    Factory.create(:localized_page).page_parts.count.should be(1)
  end
end