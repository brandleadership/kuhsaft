module Kuhsaft
  module PagePart
    class Base
      
      #
      # TODO: behave like ActiveModel for validations etc
      # http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/
      #
      def initialize hash
        hash.each_pair do |k,v|
          self.send "#{k}=", v
        end
      end
    end
  end
end