module PagesHelper
  def asset_for(id)
    Kuhsaft::Asset.find(id)
  end

  def render_markdown(text)
    RDiscount.new(text).to_html if text.present?
  end

  def homepage
    Kuhsaft::Page.roots.first
  end

  def page_for_level(num)
    input = controller.current_url if controller.respond_to? :current_url
    input ||= params[:url].presence || ''
    url = input.split('/').take(num + 1).join('/') unless input.blank?
    page = Kuhsaft::Page.find_by_url(url)
    yield page if block_given?
    page
  end

  def active_page_class(page)
    input = controller.current_url if controller.respond_to? :current_url
    input ||= params[:url].presence || ''
    input.include?(page.url.to_s) ? :active : nil
  end

  def current_page_class(page)
    :current if active_page_class(page) == :active
  end

  def read_more_link(id)
    link_to(id, :'data-toggle' => 'collapse', :'data-target' => id, :class => 'collapsed button button-read-more') do
      @content = content_tag(:p, t('kuhsaft.text_bricks.text_brick.read_more'), class: 'read-more-text')
      @content << content_tag(:p, t('kuhsaft.text_bricks.text_brick.read_less'), class: 'read-less-text')
    end
  end

  def search_page_form
    form_tag kuhsaft.pages_path, method: :get, class: 'form-inline' do
      if block_given?
        yield
      else
        render 'kuhsaft/search/form'
      end
    end
  end

  def on_kuhsaft_page?
    controller.is_a? Kuhsaft::PagesController
  end
end
