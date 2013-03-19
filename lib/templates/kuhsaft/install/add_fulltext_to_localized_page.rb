class AddFulltextToLocalizedPage < ActiveRecord::Migration
  def self.up
    add_column :localized_pages, :fulltext, :text
  end
  
  def self.down
    remove_column :localized_pages, :fulltext
  end  
end