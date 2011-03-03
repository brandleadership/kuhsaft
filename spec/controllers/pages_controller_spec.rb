require 'spec_helper'

describe Kuhsaft::PagesController do
  render_views

  describe 'should render successfully' do
    
    before :all do
      # create page with slug=deutscher-titel
      Factory.create :page
    end
    
    it '#show' do
      get :show, :slug => 'deutscher-titel'
      response.should be_success
    end
  end
end