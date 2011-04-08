module Kuhsaft
  module Admin
    class AdminController < ApplicationController
      def default_url_options
        { :locale => params[:locale].presence || :en }
      end
    end
  end
end