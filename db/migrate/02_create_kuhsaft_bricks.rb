class CreateKuhsaftBricks < ActiveRecord::Migration

  def change
    create_table :kuhsaft_bricks do |t|
      t.integer :position
      t.references :brick_list, :polymorphic => true
      t.string :type
      t.string :locale
      t.text :text
      t.text :read_more_text
      t.integer :partitioning
      t.timestamps
    end
  end

end
