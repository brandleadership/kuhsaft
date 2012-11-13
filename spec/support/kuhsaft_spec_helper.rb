module KuhsaftSpecHelper
  def create_page_tree
    page1 = create(:page)
    page2 = create(:page)
    page3 = create(:page)

    page1.childs << page2
    page1.save

    page2.childs << page3
    page2.save

    [page1, page2, page3]
  end
end
