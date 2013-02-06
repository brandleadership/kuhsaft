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
      it 'creates a new page' do
        expect { click_on 'Create Seite' }.to change(Kuhsaft::Page, :count).by(1)
      end
    end

  end
end
