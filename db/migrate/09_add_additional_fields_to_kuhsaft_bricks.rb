class AddAdditionalFieldsToKuhsaftBricks < ActiveRecord::Migration
  def change
    add_column :kuhsaft_bricks, :asset, :string
    add_column :kuhsaft_bricks, :open_in_new_window, :boolean
  end
end
