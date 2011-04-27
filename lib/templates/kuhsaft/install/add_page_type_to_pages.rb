class AddPageTypeToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :page_type, :string
  end
  
  def self.down
    remove_column :page_type, :string
  end  
end