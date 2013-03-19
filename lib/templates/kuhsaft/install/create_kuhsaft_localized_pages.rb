class CreateKuhsaftLocalizedPages < ActiveRecord::Migration
  def self.up
    create_table :localized_pages do |t|
      t.string :title
      t.string :slug
      t.string :keywords
      t.text :description
      t.text :body
      t.integer :published
      t.string :locale
      t.references :page
      t.timestamps
    end
  end
  
  def self.down
    drop_table :localized_pages
  end  
end