module Kuhsaft
  class ImageBrick < Brick
    attr_accessible :image, :caption, :link_href, :image_size
    mount_uploader :image, Kuhsaft::ImageBrickImageUploader

    validates :image, :presence => true
  end
end
