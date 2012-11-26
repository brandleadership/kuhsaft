Kuhsaft::Engine.routes.draw do
  scope :module => :cms do
    resources :pages do
      resources :bricks
    end
    resources :assets
  end
  #match '/:locale/*url' => 'pages#show', :as => :kuhsaft_page
end
