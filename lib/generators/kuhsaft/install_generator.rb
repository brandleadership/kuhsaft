require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Kuhsaft
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

   Kuhsaft::InstallGenerator.source_root(File.join(Kuhsaft::Engine.root, '/lib/templates/kuhsaft/install'))

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
end
