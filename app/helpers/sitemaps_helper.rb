module SitemapsHelper
  def locales_with_block(page)
    I18n.available_locales.each do |locale|
      I18n.with_locale locale do
        if page.url.present?
          url = "http://#{request.host_with_port}/#{page.url}"
          yield(url)
        end
      end
    end
  end
end
