require 'spec_helper'

describe 'routing to Kuhsaft::cms::AssetsController' do
  it 'routes /cms/assets to cms/assets#index' do
    { :get => '/cms/assets' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'index'
    )
  end

  it 'routes POST /cms/assets to cms/assets#create' do
    { :post => '/cms/assets' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'create'
    )
  end
  
  it 'routes PUT /cms/assets/:id to cms/assets#update' do
    { :put => '/cms/assets/1' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'update',
      :id => '1'
    )
  end
  
  it 'routes DELETE /cms/assets/:id to cms/assets#destroy' do
    { :delete => '/cms/assets/1' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'destroy',
      :id => '1'
    )
  end
  
  it 'routes /cms/assets/:id to cms/assets#show' do
    { :get => '/cms/assets/1' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'show',
      :id => '1'
    )
  end
  
  it 'routes /cms/assets/new to cms/assets#new' do
    { :get => '/cms/assets/new' }.should route_to(
      :controller => 'kuhsaft/cms/assets',
      :action => 'new'
    )  
  end
  
  it 'routes /cms/assets/:id/edit to cms/assets#edit' do
    { :get => '/cms/assets/1/edit' }.should route_to(
        :controller => 'kuhsaft/cms/assets',
        :action => 'edit',
        :id => '1'    
    )
  end
end
