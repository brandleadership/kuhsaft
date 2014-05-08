module Kuhsaft
  class Ckimage < ActiveRecord::Base
    mount_uploader :file, CkimageUploader
  end
end
