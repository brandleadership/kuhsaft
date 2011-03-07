require 'spec_helper'

describe 'routing to Kuhsaft::PagesController' do
  it 'routes /:translation_locale/:slug to pages#show' do
    { :get => '/en/my-slug' }.should route_to(
      :controller => 'kuhsaft/pages',
      :action => 'show',
      :slug => 'my-slug',
      :translation_locale => 'en'
    )
  end
  
  it 'does not expose pages#new' do
    { :get => '/pages/new' }.should_not be_routable
  end
  
  it 'does not expose pages#edit' do
    { :get => '/pages/1/edit' }.should_not be_routable
  end
  
  it 'does not expose pages#destroy' do
    { :get => '/pages/1/destroy' }.should_not be_routable
  end
end

describe 'routing to Kuhsaft::Admin::PagesController' do
  it 'routes /admin/pages to admin/pages#index' do
    { :get => '/admin/pages' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'index'
    )
  end

  it 'routes POST /admin/pages to admin/pages#create' do
    { :post => '/admin/pages' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'create'
    )
  end
  
  it 'routes PUT /admin/pages/:id to admin/pages#update' do
    { :put => '/admin/pages/1' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'update',
      :id => '1'
    )
  end
  
  it 'routes DELETE /admin/pages/:id to admin/pages#destroy' do
    { :delete => '/admin/pages/1' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'destroy',
      :id => '1'
    )
  end
  
  it 'routes /admin/pages/:id to admin/pages#show' do
    { :get => '/admin/pages/1' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'show',
      :id => '1'
    )
  end
  
  it 'routes /admin/pages/new to admin/pages#new' do
    { :get => '/admin/pages/new' }.should route_to(
      :controller => 'kuhsaft/admin/pages',
      :action => 'new'
    )  
  end
  
  it 'routes /admin/pages/:id/edit to admin/pages#edit' do
    { :get => '/admin/pages/1/edit' }.should route_to(
        :controller => 'kuhsaft/admin/pages',
        :action => 'edit',
        :id => '1'    
    )
  end
end