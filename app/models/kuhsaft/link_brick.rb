module Kuhsaft
  class LinkBrick < Brick
    attr_accessible :href, :caption

    validates :href, :caption, :presence => true
  end
end
