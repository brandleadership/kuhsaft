Kuhsaft::Engine.routes.draw do
  namespace :cms do
    devise_for :admins, :class_name => "Kuhsaft::Cms::Admin",
                        :module => :devise
    resources :pages, :except => :show
    resources :bricks, :except => [:new, :edit, :index]
    resources :assets
    root :to => 'pages#index'
  end

  match '/:locale/*url' => 'pages#show'
end
