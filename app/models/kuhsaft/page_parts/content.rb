module Kuhsaft
  module PagePart
    class Content < ActiveRecord::Base
      belongs_to :localized_page      
      serialize :content
    end
  end
end