module KuhsaftSpecHelper
  def create_page_tree
    page1 = create(:page)
    page2 = create(:page, parent: page1)
    page3 = create(:page, parent: page2)
    [page1, page2, page3]
  end
end
