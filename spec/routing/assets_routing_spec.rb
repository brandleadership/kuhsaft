require 'spec_helper'

describe 'routing to Kuhsaft::Admin::AssetsController' do
  it 'routes /admin/assets to admin/assets#index' do
    { :get => '/admin/assets' }.should route_to(
      :controller => 'kuhsaft/admin/assets',
      :action => 'index'
    )
  end

  it 'routes POST /admin/assets to admin/assets#create' do
    { :post => '/admin/assets' }.should route_to(
      :controller => 'kuhsaft/admin/assets',
      :action => 'create'
    )
  end
  
  it 'routes PUT /admin/assets/:id to admin/assets#update' do
    { :put => '/admin/assets/1' }.should route_to(
      :controller => 'kuhsaft/admin/assets',
      :action => 'update',
      :id => '1'
    )
  end
  
  it 'routes DELETE /admin/assets/:id to admin/assets#destroy' do
    { :delete => '/admin/assets/1' }.should route_to(
      :controller => 'kuhsaft/admin/assets',
      :action => 'destroy',
      :id => '1'
    )
  end
  
  it 'routes /admin/assets/:id to admin/assets#show' do
    { :get => '/admin/assets/1' }.should route_to(
      :controller => 'kuhsaft/admin/assets',
      :action => 'show',
      :id => '1'
    )
  end
  
  it 'routes /admin/assets/new to admin/assets#new' do
    { :get => '/admin/assets/new' }.should route_to(
      :controller => 'kuhsaft/admin/assets',
      :action => 'new'
    )  
  end
  
  it 'routes /admin/assets/:id/edit to admin/assets#edit' do
    { :get => '/admin/assets/1/edit' }.should route_to(
        :controller => 'kuhsaft/admin/assets',
        :action => 'edit',
        :id => '1'    
    )
  end
end