require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Kuhsaft
  module Install
    class Migrations < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root(File.join(Kuhsaft::Engine.root, '/lib/templates/kuhsaft/install'))

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def create_migration_file
        migration_template 'create_kuhsaft_pages.rb', 'db/migrate/create_kuhsaft_pages.rb'
        migration_template 'create_kuhsaft_localized_pages.rb', 'db/migrate/create_kuhsaft_localized_pages.rb'
        migration_template 'create_page_part_contents.rb', 'db/migrate/create_page_part_contents.rb'
        migration_template 'create_assets.rb', 'db/migrate/create_assets.rb'
      end
    end

    class Assets < Rails::Generators::Base
      source_root(Kuhsaft::Engine.root)
      def copy_assets
        directory 'public', 'public'
      end
    end
  end
end
