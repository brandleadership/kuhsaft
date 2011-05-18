require 'spec_helper'

describe 'routing to Kuhsaft::Cms::PagePartsController' do
  it 'routes /en/cms/pages/1/page_parts to kuhsaft/cms/page_parts#index' do
    { :get => '/en/cms/pages/1/page_parts' }.should route_to(
      :controller => 'kuhsaft/cms/page_parts',
      :action => 'index',
      :locale => 'en',
      :page_id => '1'
    )
  end

  it 'routes POST /en/cms/pages/1/page_parts to kuhsaft/cms/page_parts#create' do
    { :post => '/en/cms/pages/1/page_parts' }.should route_to(
      :controller => 'kuhsaft/cms/page_parts',
      :action => 'create',
      :locale => 'en',
      :page_id => '1'
    )
  end

  it 'routes PUT /en/cms/pages/1/page_parts/:id to kuhsaft/cms/page_parts#update' do
    { :put => '/en/cms/pages/1/page_parts/1' }.should route_to(
      :controller => 'kuhsaft/cms/page_parts',
      :action => 'update',
      :id => '1',
      :locale => 'en',
      :page_id => '1'
    )
  end

  it 'routes DELETE /en/cms/pages/1/page_parts/:id to kuhsaft/cms/page_parts#destroy' do
    { :delete => '/en/cms/pages/1/page_parts/1' }.should route_to(
      :controller => 'kuhsaft/cms/page_parts',
      :action => 'destroy',
      :id => '1',
      :locale => 'en',
      :page_id => '1'
    )
  end

  it 'routes /en/cms/pages/1/page_parts/:id to kuhsaft/cms/page_parts#show' do
    { :get => '/en/cms/pages/1/page_parts/1' }.should route_to(
      :controller => 'kuhsaft/cms/page_parts',
      :action => 'show',
      :id => '1',
      :locale => 'en',
      :page_id => '1'
    )
  end

  it 'routes /en/cms/pages/1/page_parts/new to kuhsaft/cms/page_parts#new' do
    { :get => '/en/cms/pages/1/page_parts/new' }.should route_to(
      :controller => 'kuhsaft/cms/page_parts',
      :action => 'new',
      :locale => 'en',
      :page_id => '1'
    )  
  end

  it 'routes /en/cms/pages/1/page_parts/:id/edit to kuhsaft/cms/page_parts#edit' do
    { :get => '/en/cms/pages/1/page_parts/1/edit' }.should route_to(
        :controller => 'kuhsaft/cms/page_parts',
        :action => 'edit',
        :id => '1',
        :locale => 'en',
        :page_id => '1'
    )
  end
end