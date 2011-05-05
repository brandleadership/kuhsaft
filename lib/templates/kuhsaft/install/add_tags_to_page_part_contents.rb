class AddTagsToPagePartContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :tags, :string
  end
  
  def self.down
    remove_column :contents, :tags
  end
end