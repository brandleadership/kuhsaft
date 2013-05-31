class ApplicationController < ActionController::Base
  protect_from_forgery
  helper Kuhsaft::Engine.helpers
end
