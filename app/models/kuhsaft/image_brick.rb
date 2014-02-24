module Kuhsaft
  class ImageBrick < Brick
    include Kuhsaft::ImageUploaderMounting

    validates :image,
              :image_size, presence: true

    def collect_fulltext
      [super, caption].join(' ')
    end

    def user_can_add_childs?
      false
    end
  end
end
