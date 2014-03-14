module CmsHelper
  def admin_tab(title, path)
    content_tag :li, link_to(title, path), class: (:current if request.path.include?(path))
  end

  def available_parent_pages
    pages = []
    pages << { title: t('kuhsaft.cms.pages.new.pages'), link: kuhsaft.cms_pages_path(locale: :en) }
    if params[:parent_id].present?
      parent_page = Kuhsaft::Page.find(params[:parent_id])
      pages += parent_page.parent_pages
    end
    pages << { title: t('kuhsaft.cms.pages.new.new_page'), link: '#' }
  end
end
