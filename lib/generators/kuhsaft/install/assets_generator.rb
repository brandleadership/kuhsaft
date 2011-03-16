require 'rails/generators'

module Kuhsaft
  module Install
    class Assets < Rails::Generators::Base
      source_root(Kuhsaft::Engine.root)
      def copy_assets
        directory 'public', 'public'
      end
    end
  end
end
