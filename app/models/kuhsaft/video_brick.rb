module Kuhsaft
  class VideoBrick < Brick
    attr_accessible :video, :embed_src, :href
    validates :any_source, :presence => true

    # a video id, an embed code or a link to a video is required
    def any_source
      embed_src.presence || href.presence
    end

    def self.source_types
      %w(youtube vimeo external)
    end
  end
end
