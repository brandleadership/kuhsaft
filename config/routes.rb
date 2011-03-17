Rails.application.routes.draw do
  scope :module => :kuhsaft do
    namespace :admin do
      resources :pages
      resources :assets
    end
  end
  match '/*url' => 'kuhsaft/pages#show'
end