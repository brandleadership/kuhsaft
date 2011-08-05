require 'spec_helper'

describe Kuhsaft::PagesController do
  render_views
  
  before do
    set_lang :en
    # create page with slug=english-title-1
    @page = Factory(:page)
  end
  
  after do
    Kuhsaft::Page.all.each { |p| p.destroy }
    reset_lang
  end
  
  describe 'should render successfully' do
    it '#show' do
      get :show, :locale => 'en', :url => 'english-title-1'
      response.response_code.should eq(200)
      response.should be_success
    end
  end
  
  describe 'should render 404' do
    it 'should have a 404 response code' do
      get :show, :locale => 'en', :url => '/i-dont-know'
      response.response_code.should eq(404)
    end
    
    it 'should render the 404 partial by default' do
      get :show, :locale => 'en', :url => '/i-dont-know'
      response.should render_template(:template => '404')
    end
  end
end