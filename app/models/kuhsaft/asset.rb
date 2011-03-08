class Kuhsaft::Asset < ActiveRecord::Base
  scope :by_date, order('updated_at DESC')
  mount_uploader :file, Kuhsaft::AssetUploader
end