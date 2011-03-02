module Kuhsaft
  module PagePart
    class Base
      def initialize hash
        hash.each_pair do |k,v|
          self.send "#{k}=", v
        end
      end
    end
  end
end