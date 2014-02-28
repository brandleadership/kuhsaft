class UpdateUrlAndRedirectUrlValue < ActiveRecord::Migration
  def up
    @redirect_pages = Kuhsaft::Page.where(:page_type => 'redirect')
    I18n.available_locales.each do |locale|
      move_url_to_redirect_url(locale.to_s.downcase.underscore)
    end
  end

  def down
    @redirect_pages = Kuhsaft::Page.where(:page_type => 'redirect')
    I18n.available_locales.each do |locale|
      move_redirect_url_to_url(locale.to_s.downcase.underscore)
    end

  end

  def move_url_to_redirect_url(locale)
    I18n.with_locale(locale) do
      @redirect_pages.each do |redirect_page|
        redirect_url = redirect_page.url
        redirect_page.update_attributes(:url => update_url(redirect_page), :redirect_url => redirect_url) if redirect_page
      end
    end
  end

  def move_redirect_url_to_url(locale)
    I18n.with_locale(locale) do
      @redirect_pages.each do |redirect_page|
        url = redirect_page.redirect_url
        redirect_page.update_attributes(:url => url, :redirect_url => nil, :page_type => nil) if redirect_page
      end
    end
  end

  def update_url(page)
    complete_slug = ''
    if page.parent.present?
      complete_slug << page.parent.url.to_s
    else
      complete_slug = "#{I18n.locale.to_s.downcase.underscore}"
    end
    complete_slug << "/#{page.slug}"
    complete_slug
  end
end
