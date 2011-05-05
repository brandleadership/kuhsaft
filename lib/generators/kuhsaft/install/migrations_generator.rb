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
        install_migration_once 'create_kuhsaft_pages.rb'
        install_migration_once 'create_kuhsaft_localized_pages.rb'
        install_migration_once 'create_page_part_contents.rb'
        install_migration_once 'create_assets.rb'
        install_migration_once 'add_url_to_localized_pages.rb'
        install_migration_once 'add_type_to_page_part_contents.rb'
        install_migration_once 'add_fulltext_to_localized_page.rb'
        install_migration_once 'add_page_type_to_localized_pages.rb'
        install_migration_once 'add_published_at_to_localized_pages.rb'
        install_migration_once 'add_tags_to_page_part_contents.rb'
      end
      
      private      
      def install_migration_once file
        end_path = File.join(Rails.root, 'db/migrate/')
        end_file = File.join(end_path, file)
        installed = Dir[File.join(end_path, '*.rb')].map(&:to_s).select { |f| f.include?(file) }.length > 0
        if installed
          log "The migration '#{file}' is already installed in '#{end_path}'"
        else
          migration_template(file, end_file)
        end
      end
    end
  end
end