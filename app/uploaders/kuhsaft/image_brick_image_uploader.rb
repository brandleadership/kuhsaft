# encoding: utf-8
module Kuhsaft
  class ImageBrickImageUploader < CarrierWave::Uploader::Base

    include CarrierWave::MiniMagick

    storage :file

    def store_dir
      "uploads/#{model.class.name.underscore.gsub(/^kuhsaft/,'cms')}/#{mounted_as}/#{model.id}/#{version_name.to_s}"
    end

    def full_filename(for_file)
        for_file.pathmap("%n") + for_file.pathmap("%x")
      end

    version :converted do
      process :process_brick_image_size
    end

    version :thumb, :from_version => :converted do
      process :resize_to_fill => [160, 90]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def process_brick_image_size
      image_size = Kuhsaft::ImageSize.find_by_name(model.image_size)
      if image_size.present?
        resize_to_fill(image_size.width, image_size.height)
      end
    end
  end
end
