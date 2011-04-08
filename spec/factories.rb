Factory.define :localized_page, :class => Kuhsaft::LocalizedPage do |p|
  p.locale 'en'
  p.title 'English title'
  p.published 1
  p.body 'hi'
  p.url ''
  p.association :page
end

Factory.define :page, :class => Kuhsaft::Page do |p|
  p.position 1
  p.after_create do |page|
    page.localized_pages << Factory.create(:localized_page, :page => page)
  end
end

Factory.define :asset, :class => Kuhsaft::Asset do |a|
  a.file File.open("#{Kuhsaft::Engine.root}/spec/dummy/public/images/spec-image.png")
end