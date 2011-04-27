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
        migration_template 'create_kuhsaft_pages.rb', Rails.root + 'db/migrate/create_kuhsaft_pages.rb'
        migration_template 'create_kuhsaft_localized_pages.rb', Rails.root + 'db/migrate/create_kuhsaft_localized_pages.rb'
        migration_template 'create_page_part_contents.rb', Rails.root + 'db/migrate/create_page_part_contents.rb'
        migration_template 'create_assets.rb', Rails.root + 'db/migrate/create_assets.rb'
        migration_template 'add_url_to_localized_pages.rb', Rails.root + 'db/migrate/add_url_to_localized_pages.rb'
        migration_template 'add_type_to_page_part_contents.rb', Rails.root + 'db/migrate/add_type_to_page_part_contents.rb'
        migration_template 'add_fulltext_to_localized_page.rb', Rails.root + 'db/migrate/add_fulltext_to_localized_page.rb'
        migration_template 'add_page_type_to_localized_pages.rb', Rails.root + 'db/migrate/add_page_type_to_localized_pages.rb'
        migration_template 'add_published_at_to_localized_pages.rb', Rails.root + 'db/migrate/add_published_at_to_localized_pages.rb'
      end
    end
  end
end