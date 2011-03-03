Rails.application.routes.draw do
  scope :module => :kuhsaft do
    namespace :admin do
      resources :pages
    end
  end
  match '/:slug' => 'kuhsaft/pages#show'
end