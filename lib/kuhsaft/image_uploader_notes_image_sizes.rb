require 'carrierwave'
require 'active_support/concern'

module Kuhsaft
  module ImageUploaderNotesImageSizes
    extend ActiveSupport::Concern

    included do
      extend CarrierWave::Mount

      mount_uploader :image, Kuhsaft::ImageBrickImageUploader

      after_save :resize_image_if_size_changed

      def resize_image_if_size_changed
        image.recreate_versions! if image_size_changed? && image_present?
      end

      def image_present?
        image.present?
      end
    end
  end
end
