class AddPublishedAtToLocalizedPages < ActiveRecord::Migration
  def self.up
    add_column :localized_pages, :published_at, :datetime
  end
  
  def self.down
    remove_column :published_at, :type
  end  
end