class UpdateUrlAndRedirectUrlValue < ActiveRecord::Migration
  def up
    @redirect_pages = Kuhsaft::Page.where(:page_type => 'redirect')
    I18n.available_locales.each do |locale|
      move_url_to_redirect_url(locale)
    end
  end

  def down
    @redirect_pages = Kuhsaft::Page.where(:page_type => 'redirect')
    I18n.available_locales.each do |locale|
      move_redirect_url_to_url(locale)
    end

  end

  def move_url_to_redirect_url(locale)
    I18n.with_locale(locale) do
      @redirect_pages.each do |redirect_page|
        redirect_url = redirect_page.url
        redirect_page.update_attributes(
          :redirect_url => redirect_url
        ) if redirect_page
      end
    end
  end

  def move_redirect_url_to_url(locale)
    I18n.with_locale(locale) do
      @redirect_pages.each do |redirect_page|
        url = redirect_page.redirect_url
        redirect_page.update_attributes(
          :url => url
        ) if redirect_page
      end
    end
  end
end
