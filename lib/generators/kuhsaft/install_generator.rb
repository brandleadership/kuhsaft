require 'rails/generators'
require 'rails/generators/migration'

module Kuhsaft
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    
    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
    
    def create_migration_file
      migration_template File.expand_path('../../db/migrate/create_kuhsaft_pages.rb'), 'db/migrate/create_kuhsaft_pages.rb'
      migration_template File.expand_path('../../db/migrate/create_kuhsaft_localized_pages.rb'), 'db/migrate/create_kuhsaft_localized_pages.rb'
      migration_template File.expand_path('../../db/migrate/create_page_part_contents.rb'), 'db/migrate/create_page_part_contents.rb'
      migration_template File.expand_path('../../db/migrate/create_assets.rb'), 'db/migrate/create_assets.rb'
    end
  end
end