Factory.define :page_part, :class => Kuhsaft::PagePart::Content do |p|
  p.position 1
  p.content Kuhsaft::PagePart::Markdown.new(:text => 'h1. Hello world!')
  p.association :localized_page
end

Factory.define :localized_page, :class => Kuhsaft::LocalizedPage do |p|
  p.locale 'en'
  p.title 'English title'
  p.published 1
  p.association :page
  p.after_create do |page|
    page.page_parts << Factory.build(:page_part, :localized_page => page)
  end
end

Factory.define :page, :class => Kuhsaft::Page do |p|
  p.position 1
  p.after_create do |page|
    page.localized_pages << Factory.create(:localized_page, :page => page)
  end
end