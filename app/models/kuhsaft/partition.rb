module Kuhsaft
  class Partition
      attr_reader :name, :id

      def initialize(name, id)
        @name = name
        @id = id
      end

      def self.style_for_index(style, idx)
        [
          ['span8', 'span4'],
          ['span6', 'span6'],
          ['span4', 'span8']
        ][style][idx]
      end
    end
end
