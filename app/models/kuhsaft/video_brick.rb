module Kuhsaft
  class VideoBrick < Brick
    attr_accessible :video, :embed_src, :href
    mount_uploader :video, Kuhsaft::VideoBrickVideoUploader

    validates :any_source, :presence => true

    # a video upload, an embed code or a link to a video is required
    def any_source
      video.presence || embed_src.presence || href.presence
    end
  end
end
