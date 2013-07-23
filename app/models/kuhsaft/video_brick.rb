module Kuhsaft
  class VideoBrick < Brick

    YOUTUBE = 'youtube'
    VIMEO = 'vimeo'
    EXTERNAL = 'external'

    validates :any_source, :presence => true

    # a video id, an embed code or a link to a video is required
    def any_source
      embed_src.presence || href.presence
    end

    def self.source_types
      [YOUTUBE, VIMEO, EXTERNAL]
    end

    def user_can_add_childs?
      false
    end
  end
end
