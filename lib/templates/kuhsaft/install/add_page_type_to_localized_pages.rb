class AddPageTypeToLocalizedPages < ActiveRecord::Migration
  def self.up
    add_column :localized_pages, :page_type, :string
  end
  
  def self.down
    remove_column :localized_pages, :string
  end  
end