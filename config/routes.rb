Kuhsaft::Engine.routes.draw do
  scope :module => :cms do
    resources :pages
    resources :bricks, :except => [:new, :edit, :index]
    resources :assets
  end
  #match '/:locale/*url' => 'pages#show', :as => :kuhsaft_page
end
