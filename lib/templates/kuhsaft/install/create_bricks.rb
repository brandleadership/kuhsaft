class CreateBricks < ActiveRecord::Migration

  def change
    create_table :kuhsaft_bricks do |t|
      t.integer :position
      t.string :type
      t.references :page
      t.references :brick
      t.integer :parent_id
      t.string :locale
      t.timestamps
    end
  end

end
