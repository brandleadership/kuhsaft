module Kuhsaft
  module PagePart
    class Markdown < Kuhsaft::PagePart::Content
      serialize_attr :text
      searchable_attr :text

      attr_accessible :text
    end
  end
end
