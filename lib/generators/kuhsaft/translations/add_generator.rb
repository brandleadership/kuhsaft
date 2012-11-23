require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Kuhsaft
  module Translations
    class Add < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root(File.join(Kuhsaft::Engine.root, '/lib/templates/kuhsaft/translations'))
      argument :locale, :type => :string

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def get_locale
        locale.downcase.underscore
      end
      def create_locale_migration_file
        migration_template('add_translation.html.erb', Rails.root.join('db', 'migrate', "add_#{get_locale}_translation.rb"))
      end

    end
  end
end
