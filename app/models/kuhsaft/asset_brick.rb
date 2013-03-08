module Kuhsaft
  class AssetBrick < Brick
    attr_accessible :caption, :link_style, :asset

    mount_uploader :asset, Kuhsaft::AssetBrickAssetUploader

    validates :caption, :asset, :presence => true

    def self.styles
      %w(pdf word excel button)
    end

    def to_style_class
      [super, link_style.presence].join(' ')
    end

    def collect_fulltext
      [super, caption].join(' ')
    end

    def user_can_add_childs?
      false
    end
  end
end
