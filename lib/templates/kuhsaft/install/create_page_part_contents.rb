class CreatePagePartContents < ActiveRecord::Migration

  def change
    create_table :kuhsaft_contents do |t|
      t.integer :position
      t.text :content
      t.string :type
      t.references :page
      t.timestamps
    end
  end

end
