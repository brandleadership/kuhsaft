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
  end
end
