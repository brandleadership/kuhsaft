module Kuhsaft
  class PageType
    REDIRECT = 'redirect'
    NAVIGATION = 'navigation'
    CONTENT = 'content'

    def self.all
      [CONTENT, REDIRECT, NAVIGATION]
    end
  end
end
