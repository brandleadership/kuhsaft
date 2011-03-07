class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :available_locales
  
  def available_locales
    Kuhsaft::Page.translation_locales = ['de', 'en', 'fr']
  end
end
