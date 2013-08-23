Rails.application.routes.draw do
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
  match '/*url' => 'kuhsaft/pages#show', :constraints => { :locale => /\w{2}/ }
end
