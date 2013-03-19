module Kuhsaft
  class PageType
    REDIRECT = 'redirect'
    NAVIGATION = 'navigation'
    CONTENT = ''
    
    def self.all
      [CONTENT, REDIRECT, NAVIGATION]
    end
  end
end