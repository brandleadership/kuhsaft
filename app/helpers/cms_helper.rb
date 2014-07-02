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

  def cms_brick_item(brick_list, type)
    type_name = type.class_name.constantize.model_name.human
    link_to type_name, kuhsaft.new_cms_brick_path(brick: { type: type.class_name, brick_list_id: brick_list.id, brick_list_type: brick_list.brick_list_type }), remote: true
  rescue NameError
    I18n.t type.class_name.underscore, scope: [:activerecord, :models]
  end
end
