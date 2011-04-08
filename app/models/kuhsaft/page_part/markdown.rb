module Kuhsaft
  module PagePart
    class Markdown < Kuhsaft::PagePart::Content
      serialize_attr :text
    end
  end
end