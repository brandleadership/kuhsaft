class CreateKuhsaftBricks < ActiveRecord::Migration

  def change
    create_table :kuhsaft_bricks do |t|
      t.integer :position
      t.references :brick_list, :polymorphic => true # all bricks
      t.string :type # all bricks
      t.string :locale # all bricks
      t.text :text # TextBrick
      t.text :read_more_text # TextBrick
      t.string :caption # LinkBrick
      t.text :href # LinkBrick
      t.string :link_style # LinkBrick
      t.integer :partitioning # TwoColumnBrick
      t.timestamps
    end
  end

end
