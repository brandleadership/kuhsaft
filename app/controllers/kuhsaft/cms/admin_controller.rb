module Kuhsaft
  module Cms
    class AdminController < ApplicationController
      respond_to :html
      layout 'kuhsaft/admin'
    end
  end
end
