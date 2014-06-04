# encoding: utf-8
module Kuhsaft
  class ImageBrickImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    storage :file

    def store_dir
      model_identifier = model.class.name.underscore.gsub(/^kuhsaft/, 'cms')
      "uploads/#{model_identifier}/#{mounted_as}/#{model.id}/#{version_name}"
    end

    def full_filename(for_file)
      File.basename for_file
    end

    version :converted do
      process :process_brick_image_size
    end

    version :thumb, from_version: :converted do
      process resize_to_fill: [160, 90]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def process_brick_image_size
      image_size = Kuhsaft::ImageSize.find_by_name(model.image_size)
      return unless image_size.present?
      resize_to_fill(image_size.width, image_size.height)
    end
  end
end
