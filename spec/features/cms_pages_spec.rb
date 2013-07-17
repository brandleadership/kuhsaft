# encoding: utf-8

require 'spec_helper'

describe 'Cms/Pages' do

  context '#new' do
    before do
      visit kuhsaft.new_cms_page_path
      fill_in 'Titel', :with => 'The Title of the page'
      fill_in 'Stichwörter', :with => 'My keywords'
      fill_in 'Beschreibung', :with => 'My Description'
    end

    describe '#create' do
      context 'when page is valid' do
        it 'creates a new page' do
          expect { click_on 'Create Seite' }.to change(Kuhsaft::Page, :count).by(1)
        end

        it 'is not possible to change the value in url' do
          page.find('#page_url')['disabled'].should be_true
        end
      end

      context 'when page is invalid' do
        it 'does not create a routing error by switching the locale' do
          @page = FactoryGirl.create(:page, :navigation_name => 'DummyPage', :navigation_name_en => 'DummyEN', :slug => 'dummy_page')
          visit kuhsaft.edit_cms_page_path(@page)
          fill_in 'page_title', :with => ''
          click_on 'Update Seite'
          within '.nav-pills' do
            click_on 'EN'
          end
          page.should have_content(@page.navigation_name_en)
        end
      end
    end

    describe '#update' do
      context 'when creating a redirect page' do
        before do
          @page = FactoryGirl.create(:page, :url => 'de/dumdidum')
          visit kuhsaft.edit_cms_page_path(@page)
          select 'redirect', :from => 'Seitentyp'
        end

        it 'has a value in redirect_page' do
          fill_in 'Redirect URL', :with => 'target_page'
          expect { click_on 'Update Seite' }.to change{ @page.reload.redirect_url }.to('target_page')
        end

        it 'is invalid when no value is in redirect_page' do
          click_on 'Update Seite'
          page.should have_css('.error', :count => 1)
        end

        it 'does not change the value in url' do
          fill_in 'Redirect URL', :with => 'target_page'
          expect { click_on 'Update Seite' }.to_not change{ @page.reload.url }
        end
      end
    end
  end
end
