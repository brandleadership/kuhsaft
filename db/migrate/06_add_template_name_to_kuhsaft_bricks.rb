class AddTemplateNameToKuhsaftBricks < ActiveRecord::Migration
  def change
    change_table :kuhsaft_bricks do |t|
      t.string :template_name
    end
  end
end
