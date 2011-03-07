class Kuhsaft::Asset < ActiveRecord::Base
  mount_uploader :file, Kuhsaft::AssetUploader
end