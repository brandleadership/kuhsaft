require 'spec_helper'

describe Kuhsaft::Cms::PagesController do
  render_views

  describe 'should render successfully' do
    before :all do
      # create page with ID=1 if none exists
      FactoryGirl.create :page
    end

    it '#index' do
      get :index, :locale => :en
      response.should be_success
    end

    it '#show' do
      get :show, :id => 1, :locale => :en
      response.should be_success
    end

    it '#new' do
      get :new, :locale => :en
      response.should be_success
    end

    it '#edit' do
      get :edit, :id => 1, :locale => :en
      response.should be_success
    end

    it '#create' do
      # TODO: this is ridiculous. We need to have integration tests(?) for this.
      params = { :kuhsaft_page => { :localized_pages_attributes => { 0 => { :title => 'hi', :locale => :en }}}, :locale => :en }
      post :create, params
      response.should be_redirect
    end

    it '#update' do
      # TODO: this is EXTREMELY ridiculous. We need to have integration tests(?) for this.
      page = Kuhsaft::Page.first
      localized_page = page.translation
      params = {
              :id => page.id,
              :kuhsaft_page => {
                :localized_pages_attributes => {
                  0 => {
                    :slug => "hi",
                    :title => "Hi",
                    :id => localized_page.id,
                    :description => '',
                    :locale => 'en',
                    :page_parts_attributes => {
                      0 => {
                        :text => 'some text',
                        :type => 'Kuhsaft::PagePart::Markdown'
                      }
                    }
                  }
                }}, :locale => :en }
      post :update, params
      response.should be_redirect
    end
  end
end
