require 'spec_helper'

describe Kuhsaft::PagesController do
  render_views
  
  before do
    set_lang :en
    # create page with slug=english-title
    @page = Factory.create :page
  end
  
  after do
    Kuhsaft::Page.all.each { |p| p.destroy }
    reset_lang
  end
  
  describe 'should render successfully' do
    it '#show' do
      get :show, :url => '/en/english-title'
      response.should be_success
    end
  end
end