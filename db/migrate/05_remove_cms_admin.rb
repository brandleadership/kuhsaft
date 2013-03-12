class RemoveCmsAdmin < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists?(:kuhsaft_cms_admins)
      drop_table :kuhsaft_cms_admins
    else
      puts 'kuhsaft_cms_admins table does not exist, not deleting'
    end
  end
end
