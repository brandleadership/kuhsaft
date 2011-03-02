class Kuhsaft::LocalizedPage < ActiveRecord::Base
  belongs_to :page
  has_many :page_parts, :class_name => 'Kuhsaft::PagePart::Content'
  after_save :create_slug  
  
  def locale
    read_attribute(:locale).to_sym
  end
  
  def create_slug
    self.slug = title.parameterize unless self.slug.present?
  end
end