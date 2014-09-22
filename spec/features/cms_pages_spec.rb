# encoding: utf-8

require 'spec_helper'

describe 'Cms/Pages', type: :feature do

  context '#new' do
    before do
      visit kuhsaft.new_cms_page_path
      fill_in 'Title', with: 'The Title of the page'
      fill_in 'Keywords', with: 'My keywords'
      fill_in 'Description', with: 'My Description'
    end

    describe '#create' do
      context 'when page is valid' do
        it 'creates a new page' do
          expect { click_on 'Create Page' }.to change(Kuhsaft::Page, :count).by(1)
        end

        it 'is not possible to change the value in url' do
          expect(page.find('#page_url')['disabled']).to be_truthy
        end
      end

      context 'when page is invalid' do
        it 'does not create a routing error by switching the locale' do
          @page = FactoryGirl.create(:page, title: 'DummyPage', title_en: 'DummyEN', slug: 'dummy_page')
          visit kuhsaft.edit_cms_page_path(@page)
          fill_in 'page_title', with: ''
          click_on 'Update Page'
          within '.language-navigation' do
            click_on 'EN'
          end
          expect(page).to have_content(@page.title_en)
        end
      end
    end

    describe '#update' do
      context 'when creating a redirect page' do
        before do
          @page = FactoryGirl.create(:page, url: 'de/dumdidum')
          visit kuhsaft.edit_cms_page_path(@page)
          select 'redirect', from: 'Pagetyp'
        end

        it 'has a value in redirect_page' do
          fill_in 'Redirect URL', with: 'target_page'
          expect { click_on 'Update Page' }.to change { @page.reload.redirect_url }.to('target_page')
        end

        it 'is invalid when no value is in redirect_page' do
          click_on 'Update Page'
          expect(page).to have_css('.error', count: 1)
        end

        it 'does not change the value in url' do
          fill_in 'Redirect URL', with: 'target_page'
          expect { click_on 'Update Page' }.to_not change { @page.reload.url }
        end
      end
    end
  end

  describe '#edit' do
    it 'shows error messages on invalid bricks' do
      @page = FactoryGirl.create(:page)
      invalid_brick = FactoryGirl.build(:text_brick, text: nil, brick_list: @page)
      invalid_brick.save(validate: false)

      visit kuhsaft.edit_cms_page_path(@page)
      expect(page).to have_css('.error', count: 1)
    end
  end
end
