module Kuhsaft
  module PagePart

    def self.all
      descendants = []
      ObjectSpace.each_object(Class) do |k|
        descendants.unshift k if k < self
      end
      descendants.uniq!
      descendants.map { |d| d.to_s.underscore.to_sym }
    end

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
