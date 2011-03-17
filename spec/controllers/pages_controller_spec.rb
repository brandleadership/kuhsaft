require 'spec_helper'

describe Kuhsaft::PagesController do
  render_views

  describe 'should render successfully' do
    
    before :all do
      # create page with slug=english-title
      Factory.create :page
    end
    
    it '#show' do
      get :show, :url => '/en/english-title'
      response.should be_success
    end
  end
end