class AddUrlToLocalizedPages < ActiveRecord::Migration
  def self.up
    add_column :localized_pages, :url, :string
  end
  
  def self.down
    remove_column :localized_pages, :url
  end  
end