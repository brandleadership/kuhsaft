class AddRedirectUrlToKuhsaftPages < ActiveRecord::Migration
  def change
    add_column :kuhsaft_pages, :redirect_url_de, :text
    add_column :kuhsaft_pages, :redirect_url_en, :text
  end
end
