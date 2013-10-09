require 'carrierwave'
require 'active_support/concern'

module Kuhsaft
  module ImageUploaderNotesImageSizes
    extend ActiveSupport::Concern
    extend CarrierWave::Mount

    included do
      mount_uploader :image, Kuhsaft::ImageBrickImageUploader
    end
  end
end
