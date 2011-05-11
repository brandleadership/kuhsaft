Rails.application.routes.draw do
  scope :module => :kuhsaft do
    scope ':locale' do
      namespace :cms do
        resources :pages
        resources :assets
      end
    end
  end
  match '/*url' => 'kuhsaft/pages#show'
end
