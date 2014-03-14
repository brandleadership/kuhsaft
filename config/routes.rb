Kuhsaft::Engine.routes.draw do
  namespace :cms do
    resources :pages, except: :show do
      post :sort, on: :collection
    end
    resources :bricks, except: [:edit, :index] do
      post :sort, on: :collection
    end

    resources :assets
    root to: 'pages#index'
  end

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    resources :pages,
              only: [:index],
              defaults: { locale: I18n.locale }
    get '(*url)' => 'pages#show', :as => :page
  end

  get '/sitemap.:format' => 'sitemaps#index', format: 'xml'
end
