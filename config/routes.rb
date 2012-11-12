Kuhsaft::Engine.routes.draw do
  scope :module => :kuhsaft do
    scope ':locale' do
      namespace :cms do
        resources :pages do
          resources :page_parts
        end
        resources :assets
      end
    end
  end
  match '/:locale/*url' => 'kuhsaft/pages#show'
end
