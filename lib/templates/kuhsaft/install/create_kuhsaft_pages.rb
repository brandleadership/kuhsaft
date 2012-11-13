class CreateKuhsaftPages < ActiveRecord::Migration

  def change
    create_table :kuhsaft_pages do |t|
      t.integer :position
      t.integer :parent_id
      t.string :title
      t.string :slug
      t.string :keywords
      t.text :description
      t.text :body
      t.integer :published
      t.references :page
      t.text :url
      t.string :page_type
      t.text :fulltext
      t.timestamps
    end
  end

end
