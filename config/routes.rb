Rails.application.routes.draw do
  scope :module => :kuhsaft do
    scope ':locale' do
      namespace :cms do
        resources :pages
      end
    end

    namespace :cms do
      resources :assets
    end
  end
  match '/*url' => 'kuhsaft/pages#show'
end
