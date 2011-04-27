Rails.application.routes.draw do
  scope :module => :kuhsaft do
    scope ':locale' do
      namespace :admin do
        resources :pages
      end
    end

    namespace :admin do
      resources :assets
    end
  end
  match '/*url' => 'kuhsaft/pages#show'
end