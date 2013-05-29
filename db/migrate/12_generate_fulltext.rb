class GenerateFulltext < ActiveRecord::Migration
  def up
    Kuhsaft::Page.all.each do |p|
      I18n.available_locales.each do |locale|
        I18n.with_locale { p.save! }
      end
    end
  end
end
