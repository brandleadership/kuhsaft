module Kuhsaft
  class ImageSize
    attr_accessor :name, :width, :height

    class << self
      def all
        [gallery_size, teaser_size]
      end

      def gallery_size
        @gallery_size ||= ImageSize.new.tap do |size|
          size.name = :gallery
          size.width = 960
          size.height = 540
        end
      end

      def teaser_size
        @teaser_size ||= ImageSize.new.tap do |size|
          size.name = :teaser
          size.width = 320
          size.height = 180
        end
      end
    end

  end
end
