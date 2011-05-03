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

describe 'routing to Kuhsaft::cms::PagesController' do
  it 'routes /en/cms/pages to cms/pages#index' do
    { :get => '/en/cms/pages' }.should route_to(
      :controller => 'kuhsaft/cms/pages',
      :action => 'index',
      :locale => 'en'
    )
  end

  it 'routes POST /en/cms/pages to cms/pages#create' do
    { :post => '/en/cms/pages' }.should route_to(
      :controller => 'kuhsaft/cms/pages',
      :action => 'create',
      :locale => 'en'
    )
  end
  
  it 'routes PUT /en/cms/pages/:id to cms/pages#update' do
    { :put => '/en/cms/pages/1' }.should route_to(
      :controller => 'kuhsaft/cms/pages',
      :action => 'update',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes DELETE /en/cms/pages/:id to cms/pages#destroy' do
    { :delete => '/en/cms/pages/1' }.should route_to(
      :controller => 'kuhsaft/cms/pages',
      :action => 'destroy',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes /en/cms/pages/:id to cms/pages#show' do
    { :get => '/en/cms/pages/1' }.should route_to(
      :controller => 'kuhsaft/cms/pages',
      :action => 'show',
      :id => '1',
      :locale => 'en'
    )
  end
  
  it 'routes /en/cms/pages/new to cms/pages#new' do
    { :get => '/en/cms/pages/new' }.should route_to(
      :controller => 'kuhsaft/cms/pages',
      :action => 'new',
      :locale => 'en'
    )  
  end
  
  it 'routes /en/cms/pages/:id/edit to cms/pages#edit' do
    { :get => '/en/cms/pages/1/edit' }.should route_to(
        :controller => 'kuhsaft/cms/pages',
        :action => 'edit',
        :id => '1',
        :locale => 'en'    
    )
  end
end
