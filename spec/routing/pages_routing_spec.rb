require 'spec_helper'

describe 'routing to Kuhsaft::PagesController' do
  it 'routes /*url to pages#show' do
    { :get => '/en/my-slug' }.should route_to(
      :controller => 'kuhsaft/pages',
      :action => 'show',
      :url => 'en/my-slug'
    )
  end
end

describe 'routing to Kuhsaft::Admin::PagesController' do
  it 'routes /en/admin/pages to admin/pages#index' do
    { :get => '/en/admin/pages' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'index',
      :locale => 'en'
    )
  end

  it 'routes POST /en/admin/pages to admin/pages#create' do
    { :post => '/en/admin/pages' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'create',
      :locale => 'en'
    )
  end
  
  it 'routes PUT /en/admin/pages/:id to admin/pages#update' do
    { :put => '/en/admin/pages/1' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'update',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes DELETE /en/admin/pages/:id to admin/pages#destroy' do
    { :delete => '/en/admin/pages/1' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'destroy',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes /en/admin/pages/:id to admin/pages#show' do
    { :get => '/en/admin/pages/1' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'show',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes /en/admin/pages/new to admin/pages#new' do
    { :get => '/en/admin/pages/new' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'new',
      :locale => 'en'
    )  
  end
  
  it 'routes /en/admin/pages/:id/edit to admin/pages#edit' do
    { :get => '/en/admin/pages/1/edit' }.should route_to(
        :controller => 'kuhsaft/admin/pages',
        :action => 'edit',
        :id => '1',
        :locale => 'en'    
    )
  end
end