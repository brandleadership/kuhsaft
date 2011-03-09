require 'spec_helper'

describe Kuhsaft::Admin::AssetsController do
  render_views
  
  before do
    Factory.create :asset
  end
  
  describe 'should render successfully' do
    it '#index' do
      get :index
      response.should be_success
    end
    
    it '#new' do
      get :new
      response.should be_success
    end
    
    it '#edit' do
      get :edit, :id => 1
      response.should be_success
    end
  end
end