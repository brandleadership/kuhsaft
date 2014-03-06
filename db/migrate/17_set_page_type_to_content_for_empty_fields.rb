class SetPageTypeToContentForEmptyFields < ActiveRecord::Migration
  def change
    Kuhsaft::Page.where( "page_type is NULL or page_type = ''" ).each do |page|
      page.update_attribute(:page_type, Kuhsaft::PageType::CONTENT)
    end
  end
end
