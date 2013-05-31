class RegenerateFulltext < ActiveRecord::Migration
  def up
    Kuhsaft::Page.all.each do |p|
      I18n.available_locales.each do |locale|
        I18n.with_locale do
          puts "Save #{p.locale_attr(:fulltext)} #{p.link}"
          p.save!
        end
      end
    end
  end
end
