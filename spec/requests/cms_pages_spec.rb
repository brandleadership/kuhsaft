require 'spec_helper'

describe 'Cms Pages Backend' do
  
  context 'when creating a new root page' do
    before do
      visit cms_pages_path(:locale => :en)
      click_link 'Create'
    end
    
    it 'should display a blank page form' do
      page.should have_selector(:new_kuhsaft_page)
    end
    
    context 'when submitting the form' do 
      before do
        fill_in 'kuhsaft_page_localized_pages_attributes_0_title', :with => 'My first page'
        click_button 'Create Page'
      end
      
      it 'should create a  new page' do
        pending 'how wo we test this'
        page.should have_content 'My first page'
      end
    end
  end
end