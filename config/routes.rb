Kuhsaft::Engine.routes.draw do
  namespace :cms do
    resources :pages, :except => :show
    resources :bricks, :except => [:new, :edit, :index]
    resources :assets
    root :to => 'pages#index'
  end

  match '/:locale/*url' => 'pages#show'
end
