module Kuhsaft
  class ImageSize
    attr_accessor :name, :width, :height

    def label
      I18n.t("activerecord.attributes.kuhsaft/image_size.sizes.#{name}")
    end

    class << self
      def all
        @all ||= []
      end

      def build_defaults!
        @all = [gallery_size, teaser_size]
      end

      def find_by_name(name)
        all.find { |size| size.name.to_s == name.to_s }
      end

      def clear!
        @all = []
      end

      def add(name, width, height)
        @all << ImageSize.new.tap do |size|
          size.name = name.to_sym
          size.width = width
          size.height = height
        end
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
