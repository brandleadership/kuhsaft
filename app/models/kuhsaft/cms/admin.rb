module Kuhsaft
  module Cms
    class Admin < ActiveRecord::Base
      devise :database_authenticatable, :rememberable
      attr_accessible :email, :password, :password_confirmation, :remember_me

      def admin?
        true
      end

      def editor?
        false
      end

      def author?
        false
      end
    end
  end
end
