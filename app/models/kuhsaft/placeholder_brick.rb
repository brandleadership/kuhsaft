module Kuhsaft
  class PlaceholderBrick < Brick
    include Kuhsaft::PartialExtractor

    attr_accessible :template_name

    def self.available_partials
      @partials ||= Kuhsaft::PartialExtractor.partials('/app/views/user_templates/_*.haml')
    end

    def render_as_horizontal_form?
      true unless parents.map(&:class).include? Kuhsaft::TwoColumnBrick
    end
  end
end
