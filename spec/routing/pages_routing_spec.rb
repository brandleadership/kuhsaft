require 'spec_helper'

describe 'routing to Kuhsaft::PagesController' do
  it 'routes /pages to pages#index' do
    { :get => '/pages' }.should route_to(
      :controller => 'kuhsaft/pages',
      :action => 'index'
    )
  end
  
  it 'routes /pages/:id to pages#show' do
    { :get => '/pages/1' }.should route_to(
      :controller => 'kuhsaft/pages',
      :action => 'show',
      :id => '1'
    )
  end
  
  it 'routes /pages/new to pages#new' do
    { :get => '/pages/new' }.should route_to(
      :controller => 'kuhsaft/pages',
      :action => 'new'
    )
  end
  
  it 'routes /pages/:id/edit to pages#edit' do
    { :get => '/pages/1/edit' }.should route_to(
      :controller => 'kuhsaft/pages',
      :action => 'edit',
      :id => '1'    
    )
  end  
end