class Kuhsaft::LocalizedPage < ActiveRecord::Base
  belongs_to :page
  has_many :page_parts, :class_name => 'Kuhsaft::PagePart::Content'
  before_save :create_slug  
  
  validate :title, :presence => true
  validate :locale, :presence => true
  validate :slug, :presence => true
  
  def locale
    read_attribute(:locale).to_sym unless read_attribute(:locale).nil?
  end
  
  def create_slug
    self.slug = read_attribute(:title).downcase.parameterize unless self.slug.present? || read_attribute(:title).nil?
  end
end