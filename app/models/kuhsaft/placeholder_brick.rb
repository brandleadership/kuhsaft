module Kuhsaft
  class PlaceholderBrick < Brick
    attr_accessible :template_name

    def self.available_partials
      partials = []
      Dir.glob("#{Rails.root}/app/views/user_templates/_*.haml").each do |partial|
        filename = File.basename(partial).split('.', 0).first
        filename.slice!(0)
        partials << filename
      end
      partials.collect {|d| [I18n.t(d), d]}
    end

    def render_as_horizontal_form?
      true unless parents.map(&:class).include? Kuhsaft::TwoColumnBrick
    end
  end
end
