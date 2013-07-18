class AddNavigationNameToPages < ActiveRecord::Migration
  def change
    I18n.available_locales.each do |locale|
      add_column :kuhsaft_pages, "navigation_name_#{locale}", :string
    end
  end
end
