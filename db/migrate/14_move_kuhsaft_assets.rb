class MoveKuhsaftAssets < ActiveRecord::Migration
  def old_kuhsaft_assets_dir
    File.join(Rails.root,'public/uploads/kuhsaft')
  end

  def new_kuhsaft_assets_dir
    File.join(Rails.root,'public/uploads/cms')
  end

  def up
    if File.exists? old_kuhsaft_assets_dir
      puts "Moving Kuhsaft Assets from #{old_kuhsaft_assets_dir} to #{new_kuhsaft_assets_dir}"
      File.rename old_kuhsaft_assets_dir, new_kuhsaft_assets_dir
    end
  end

  def down
    if File.exists? new_kuhsaft_assets_dir
      File.rename new_kuhsaft_assets_dir, old_kuhsaft_assets_dir
    end
  end
end
