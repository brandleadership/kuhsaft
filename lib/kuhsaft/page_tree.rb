module Kuhsaft
  module PageTree
    extend self

    def update(params, parent_id = nil)
      params.each do |page_position, page_content|
        page = Page.find(page_content['id'])
        page.update_attributes(parent_id: parent_id, position: page_position)
        next if page_content['children'].nil?
        update(page_content['children'], page.id)
      end
    end
  end
end
