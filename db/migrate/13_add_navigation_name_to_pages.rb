class AddNavigationNameToPages < ActiveRecord::Migration
  def up
    I18n.available_locales.each do |locale|
      add_column :kuhsaft_pages, "navigation_name_#{locale}", :string
    end
    move_title_data_to_navigation_name
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

def move_title_data_to_navigation_name
  I18n.available_locales.each do |locale|
    Kuhsaft::Page.all.each do |page|
      page.update_attribute(navigation_name: page.title)
    end
  end
end
