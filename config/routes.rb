Kuhsaft::Engine.routes.draw do

  namespace :cms do
    resources :pages, except: :show do
      post :sort, on: :collection
      get :mirror
    end

    resources :bricks, except: [:edit, :index] do
      post :sort, on: :collection
    end

    resources :assets
    resources :ckimages, only: [:create, :index, :destroy]
    root to: 'pages#index'
  end

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    namespace :api, defaults: { format: :json } do
      resources :pages, only: :index
    end

    resources :pages,
              only: [:index],
              defaults: { locale: I18n.locale }
    get '(*url)' => 'pages#show', as: :page
  end

  get '/pages/:id' => 'pages#lookup_by_id'
  get '/sitemap' => 'sitemaps#index', format: 'xml'
end
