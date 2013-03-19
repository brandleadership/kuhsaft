class CreatePagePartContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :position
      t.text :content
      t.references :localized_page
      t.timestamps
    end
  end
  
  def self.down
    drop_table :contents
  end  
end