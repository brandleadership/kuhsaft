class CreateKuhsaftBrickTypes < ActiveRecord::Migration

  def change
    create_table :kuhsaft_brick_types do |t|
      t.string :class_name
      t.string :group
      t.boolean :disabled
      t.timestamps
    end
  end

end
