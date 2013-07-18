class AddPageTitleToPages < ActiveRecord::Migration
  def change
    I18n.available_locales.each do |locale|
      add_column :kuhsaft_pages, "page_title_#{locale}", :text
    end
  end
end
