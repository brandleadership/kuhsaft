module KuhsaftSpecHelper
  def create_page_tree
    page1 = FactoryGirl.create :page
    page2 = FactoryGirl.create :page
    page3 = FactoryGirl.create :page

    page1.childs << page2
    page1.save

    page2.childs << page3
    page2.save

    [page1, page2, page3]
  end
end
