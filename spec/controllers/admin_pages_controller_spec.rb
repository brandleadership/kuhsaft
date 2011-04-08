require 'spec_helper'

describe Kuhsaft::Admin::PagesController do
  render_views

  describe 'should render successfully' do
    before :all do
      # create page with ID=1 if none exists
      Factory.create :page
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
      params = { :kuhsaft_page => { :localized_pages_attributes => { 0 => { :title => 'hi', :locale => :en }}}, :locale => :en }
      post :create, params
      response.should be_redirect
    end
  end
end