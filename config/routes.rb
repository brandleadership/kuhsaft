Rails.application.routes.draw do
  scope :module => :kuhsaft do
    resources :pages
  end
end