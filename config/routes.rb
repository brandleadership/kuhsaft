Rails.application.routes.draw do
  scope :module => :kuhsaft do
    namespace :admin do
      resources :pages
      resources :assets
    end
  end
  match '/:translation_locale/:slug' => 'kuhsaft/pages#show', :constraints => { :translation_locale => /[a-zA-Z]{2}/ }
end