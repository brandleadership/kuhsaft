class MoveTitleContentToNavigationNameOnPages < ActiveRecord::Migration
  def change
    I18n.available_locales.each do |locale|
      move_title_data_to_navigation_name(locale)
    end
  end
end

def move_title_data_to_navigation_name
  Kuhsaft::Page.all.each do |page|
    page.navigation_name = page.title
    page.title = nil
    page.save
  end
end
