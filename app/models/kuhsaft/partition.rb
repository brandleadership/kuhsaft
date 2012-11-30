module Kuhsaft
  class Partition
      attr_reader :name, :id

      def initialize(name, id)
        @name = name
        @id = id
      end

      def self.style_for_index(style, idx)
        [
          ['span4', 'span8'],
          ['span6', 'span6'],
          ['span8', 'span4']
        ][style][idx]
      end
    end
end
