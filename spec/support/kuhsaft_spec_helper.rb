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
    page1 = FactoryGirl.create :page
    page1.translation.update_attribute :title, 'English Title 1'
    page2 = FactoryGirl.create :page
    page2.translation.update_attribute :title, 'English Title 2'
    page3 = FactoryGirl.create :page
    page3.translation.update_attribute :title, 'English Title 3'

    page1.childs << page2
    page1.save

    page2.childs << page3
    page2.save

    [page1, page2, page3]
  end
end
