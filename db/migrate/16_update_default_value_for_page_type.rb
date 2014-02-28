class UpdateDefaultValueForPageType < ActiveRecord::Migration
  def up
    change_column :kuhsaft_pages, :page_type, :string, :default => Kuhsaft::PageType::CONTENT
  end

  def down
    change_column_default(:kuhsaft_pages, :page_type, nil)
  end
end
