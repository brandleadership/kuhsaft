class Kuhsaft::Asset < ActiveRecord::Base
  scope :by_date, order('updated_at DESC')
  mount_uploader :file, Kuhsaft::AssetUploader
  
  def file_type
    if file.url.present? && ext = file.url.split('.').last
      ext.to_sym unless ext.blank?
    end
  end
  
  def name
    File.basename(file.path) if file.present? && file.path.present?
  end
  
  def path
    file.url
  end
  
  def path=val
    # do nothing
  end
  
  def filename
    try(:file).try(:file).try(:filename)
  end
end