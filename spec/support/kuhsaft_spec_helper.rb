module KuhsaftSpecHelper
  def set_lang lang
    @remember_translation_locale = Kuhsaft::Page.current_translation_locale
    Kuhsaft::Page.current_translation_locale = lang
  end
  
  def reset_lang
    Kuhsaft::Page.current_translation_locale = @remember_translation_locale if @remember_translation_locale.present?
  end
  
  def destroy_all_pages
    Kuhsaft::Page.all.each { |p| p.destroy }
    Kuhsaft::LocalizedPage.all.each { |p| p.destroy }
  end
  
  def create_page_tree
    page1 = Factory.create :page
    page2 = Factory.create :page
    page3 = Factory.create :page
    
    page1.childs << page2
    page1.save
    
    page2.childs << page3
    page2.save
    
    [page1, page2, page3]
  end
end