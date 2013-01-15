module Kuhsaft
  class LinkBrick < Brick
    attr_accessible :href, :caption, :link_style

    validates :href, :caption, :presence => true

    def self.styles
      %w(pdf word excel button external)
    end

    def to_style_class
      [super, link_style.presence].join(' ')
    end

    def collect_fulltext
      [super, caption].join(' ')
    end
  end
end
