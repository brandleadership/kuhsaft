require 'spec_helper'

describe Kuhsaft::PagesController do
  describe '#show' do
    around(:each) do |example|
      I18n.with_locale :de do
        example.run
      end
    end

    context 'when page is not a redirect page' do
      it 'responds with page' do
        page = FactoryGirl.create(:page, :slug => 'dumdidum', :url => 'de/dumdidum')
        get :show,  { :url => page.slug, :use_route => :kuhsaft, :locale => :de }
        assigns(:page).should eq(page)
      end
    end

    context 'when page is a redirect page' do
      it 'redirects to the redirected url' do
        page = FactoryGirl.create(:page, :page_type => 'redirect', :slug => 'dumdidum', :url => 'de/dumdidum', :redirect_url => 'de/redirect_page')
        get :show,  { :url => page.slug, :use_route => :kuhsaft, :locale => :de }
        expect(response).to redirect_to("/de/redirect_page")
      end
    end
  end
end

