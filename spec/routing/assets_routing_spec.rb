require 'spec_helper'

describe 'routing to Kuhsaft::cms::AssetsController' do
  it 'routes /en/cms/assets to cms/assets#index' do
    { :get => '/en/cms/assets' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'index', 
      :locale => 'en'
    )
  end

  it 'routes POST /en/cms/assets to cms/assets#create' do
    { :post => '/en/cms/assets' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'create',
      :locale => 'en'
    )
  end
  
  it 'routes PUT /en/cms/assets/:id to cms/assets#update' do
    { :put => '/en/cms/assets/1' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'update',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes DELETE /en/cms/assets/:id to cms/assets#destroy' do
    { :delete => '/en/cms/assets/1' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'destroy',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes /en/cms/assets/:id to cms/assets#show' do
    { :get => '/en/cms/assets/1' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'show',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes /en/cms/assets/new to cms/assets#new' do
    { :get => '/en/cms/assets/new' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'new',
      :locale => 'en'
    )  
  end
  
  it 'routes /en/cms/assets/:id/edit to cms/assets#edit' do
    { :get => '/en/cms/assets/1/edit' }.should route_to(
        :controller => 'kuhsaft/cms/assets',
        :action => 'edit',
        :id => '1',
        :locale => 'en' 
    )
  end
end
