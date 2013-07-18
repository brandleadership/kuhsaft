class AddNavigationNameToPages < ActiveRecord::Migration
  def change
    I18n.available_locales.each do |locale|
      add_column :kuhsaft_pages, "navigation_name_#{locale}", :string
    end
    move_title_data_to_navigation_name
  end
end

def move_title_data_to_navigation_name
  I18n.available_locales.each do |locale|
    Kuhsaft::Page.all.each do |page|
      page.navigation_name = page.title
      page.title = nil
      page.save
    end
  end
end
