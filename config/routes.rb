Kuhsaft::Engine.routes.draw do
  namespace :cms do
    resources :pages, :except => :show
    resources :bricks, :except => [:new, :edit, :index] do
      post :sort, :on => :collection
    end

    resources :assets
    root :to => 'pages#index'
  end

  scope "(:locale)", :locale => /#{I18n.available_locales.join('|')}/ do
    resources :pages, :only => [:index]
    match '*url' => 'pages#show'
  end
end
