module PagesHelper
  def current_page
    lang = Kuhsaft::Page.current_translation_locale
    page = Kuhsaft::Page.find(@page.id).localized_pages.where('locale = ?', lang).first.page
    page.translation
    return page
  rescue
  end
  
  def current_page_path(lang=nil)
    if @page.present?
      '/' + Kuhsaft::Page.find(@page.id).localized_pages.where('locale = ?', lang).first.url
    else
      root_path
    end
  rescue
    root_path
  end

  def asset_for id
    Kuhsaft::Asset.find(id)
  end

  def navigation_for id
    if id.blank?
      Kuhsaft::Page.root_pages
    else
      Kuhsaft::Page.where('parent_id = ?', id)
    end
  end

  def page_for_level num
    url = params[:url].split('/').take(num + 1).join('/') unless params[:url].blank?
    Kuhsaft::Page.find_by_url(url)
  end

  def active_page_class page
    url = params[:url].presence || ''
    url.include?(page.url.to_s) ? 'active' : nil
  end

  def current_page_class page
    'current' if active_page_class(page) == 'active'
  end
end