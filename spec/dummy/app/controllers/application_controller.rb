class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :available_locales
  
  def available_locales
    Kuhsaft::Page.translation_locales = ['de', 'en', 'fr']
    Kuhsaft::Page.current_translation_locale = params[:locale] if params[:locale].present?
  end
end
