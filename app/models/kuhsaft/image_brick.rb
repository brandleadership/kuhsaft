module Kuhsaft
  class ImageBrick < Brick
    include Kuhsaft::ImageUploaderNotesImageSizes

    validates :image, :presence => true
    validates :image_size, :presence => true



    def collect_fulltext
      [super, caption].join(' ')
    end

    def user_can_add_childs?
      false
    end


  end
end
