class AddAltTextToBricks < ActiveRecord::Migration
  def change
    add_column :kuhsaft_bricks, :alt_text, :string
  end
end
