module Kuhsaft
  class PageType
    REDIRECT = 'redirect'
    NAVIGATION = 'navigation'
    CONTENT = 'content'
    CUSTOM = 'custom'

    def self.all
      [CONTENT, REDIRECT, NAVIGATION, CUSTOM]
    end
  end
end
