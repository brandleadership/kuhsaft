FactoryGirl.define do
  sequence(:title) { |n| n }

  factory :page, :class => 'Kuhsaft::Page' do |p|
    p.position 1
    p.after_create do |page|
      page.localized_pages << FactoryGirl.create(:localized_page, :page => page)
    end
  end

  factory :localized_page, :class => 'Kuhsaft::LocalizedPage' do |p|
    p.locale 'en'
    p.title { "English Title #{FactoryGirl.generate(:title)}" }
    p.published 1
    p.body 'hi'
    p.url ''
    p.association :page
  end

  factory :asset, :class => Kuhsaft::Asset do |a|
    a.file File.open("#{Kuhsaft::Engine.root}/spec/dummy/app/assets/images/spec-image.png")
  end
end
