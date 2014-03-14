require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Kuhsaft
  module Translations
    class Add < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root(File.join(Kuhsaft::Engine.root, '/lib/templates/kuhsaft/translations'))
      argument :locale, type: :string

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def translated_columns
        Kuhsaft::Page.column_names.select { |attr| attr.include?("_#{I18n.default_locale}") }
      end

      def get_locale
        locale.downcase.underscore
      end

      def create_locale_migration_file
        migration_template('add_translation.html.erb', Rails.root.join('db', 'migrate', "add_#{get_locale}_translation.rb"))
      end

      private

      def get_attribute(attribute_name = '')
        attribute_name.gsub("_#{I18n.default_locale}", "_#{get_locale}")
      end

      def get_type(key = '')
        Kuhsaft::Page.columns_hash[key].type
      end
    end
  end
end
