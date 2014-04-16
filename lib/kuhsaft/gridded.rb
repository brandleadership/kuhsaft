module Kuhsaft
  module Gridded
    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def gridded?
        col_count != 0
      end
    end

    module ClassMethods
      def available_grid_sizes
        (0..12).to_a
      end
    end
  end
end
