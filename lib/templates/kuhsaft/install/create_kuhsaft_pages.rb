class CreateKuhsaftPages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :position
      t.integer :parent_id
      t.references :page
      t.timestamps
    end
  end
  
  def self.down
    drop_table :pages
  end  
end