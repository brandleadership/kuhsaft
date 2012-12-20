module Kuhsaft
  module Cms
    class Admin < ActiveRecord::Base
      devise :database_authenticatable, :rememberable
      attr_accessible :email, :password, :password_confirmation, :remember_me
    end
  end
end
