require 'spec_helper'

describe Kuhsaft::Cms::AssetsController do
  render_views

  before do
    FactoryGirl.create :asset
  end

  describe 'should render successfully' do
    it '#index' do
      get :index, :locale => :en
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
  end
end
