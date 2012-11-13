require 'spec_helper'

describe Kuhsaft::PagesController do
  render_views

  before do
    create(:page, :slug => 'english-title-1')
  end

  describe 'should render successfully' do
    it '#show' do
      get :show, :locale => 'en', :url => 'english-title-1'
      response.response_code.should eq(200)
      response.should be_success
    end
  end

  describe 'should render 404' do
    it 'should raise RoutingError by default' do
      expect{ get :show, :locale => 'en', :url => '/i-dont-know' }.to raise_error(ActionController::RoutingError)
    end
  end
end
