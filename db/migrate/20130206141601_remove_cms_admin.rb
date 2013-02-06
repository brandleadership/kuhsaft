class RemoveCmsAdmin < ActiveRecord::Migration
  def change
    begin
      remove_table :kuhsaft_cms_admins
    rescue
      puts 'kuhsaft_cms_admins table does not exist, not deleting'
    end
  end
end
