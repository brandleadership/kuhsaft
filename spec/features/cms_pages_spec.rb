require 'spec_helper'

describe 'Cms/Pages' do
  sign_in_cms_admin

  context '#new' do
    before do
      visit kuhsaft.new_page_path
      fill_in 'Title', :with => 'The Title of the page'
      fill_in 'Keywords', :with => 'My keywords'
      fill_in 'Description', :with => 'My Description'
    end

    describe '#create' do
      it 'creates a new page' do
        expect { click_on 'Create Page' }.to change(Kuhsaft::Page, :count).by(1)
      end
    end

  end
end
