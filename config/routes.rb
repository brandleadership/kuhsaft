Kuhsaft::Engine.routes.draw do
  scope :module => :cms do
    devise_for :admins, :class_name => "Kuhsaft::Cms::Admin",
                        :module => :devise
    resources :pages
    resources :bricks, :except => [:new, :edit, :index]
    resources :assets
  end

  #match '/:locale/*url' => 'pages#show', :as => :kuhsaft_page
end
