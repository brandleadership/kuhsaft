module PagesHelper
  def current_page
    lang = Kuhsaft::Page.current_translation_locale
    page = Kuhsaft::Page.find(@page.id).localized_pages.where('locale = ?', lang).first.page
    page.translation
    yield page if block_given?
    page
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

  def navigation_for options
    if options.is_a?(Hash) && slug = options.delete(:slug)
      pages = Kuhsaft::LocalizedPage.navigation(slug).first.page.childs
    elsif (options.is_a?(Fixnum) && id = options) ||  id = options.delete(:id)
      pages = Kuhsaft::Page.where('parent_id = ?', id)
    elsif options.nil?
      pages = Kuhsaft::Page.root_pages
    end
    yield pages if block_given? && pages.length > 0
    pages
  end
  
  def homepage
    Kuhsaft::Page.root_pages.first
  end
  
  def page_for_level num
    url = params[:url].split('/').take(num + 1).join('/') unless params[:url].blank?
    page = Kuhsaft::Page.find_by_url(url)
    yield page if block_given?
    page
  rescue
  end

  def active_page_class page
    url = params[:url].presence || ''
    url.include?(page.url.to_s) ? :active : nil
  end

  def current_page_class page
    :current if active_page_class(page) == :active
  end
end