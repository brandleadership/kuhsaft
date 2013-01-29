module Kuhsaft
  class PlaceholderBrick < Brick

    attr_accessible :template_name
    PARTIAL_PATH = '/app/views/kuhsaft/placeholder_bricks/partials/_*.haml'

    def self.available_partials
      @partials ||= Kuhsaft::PartialExtractor.new.partials(PARTIAL_PATH)
    end

    def render_as_horizontal_form?
      true unless parents.map(&:class).include? Kuhsaft::TwoColumnBrick
    end
  end
end
