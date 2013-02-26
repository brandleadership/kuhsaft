class AddDefaultValueToBrickTypeEnabled < ActiveRecord::Migration
  def change
    rename_column :kuhsaft_brick_types, :disabled, :enabled
    change_column :kuhsaft_brick_types, :enabled, :boolean, :default => true
  end
end
