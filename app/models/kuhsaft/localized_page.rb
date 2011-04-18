class Kuhsaft::LocalizedPage < ActiveRecord::Base
  belongs_to :page
  has_many :page_parts, :class_name => 'Kuhsaft::PagePart::Content', :autosave => true
  before_validation :create_slug
  before_validation :create_url
  
  delegate :childs, :to => :page
  
  validates :title, :presence => true
  validates :locale, :presence => true
  validates :slug, :presence => true
  
  accepts_nested_attributes_for :page_parts
  
  def locale
    read_attribute(:locale).to_sym unless read_attribute(:locale).nil?
  end
  
  def create_url
    complete_slug = ''
    if page.present? && page.parent.present?
      complete_slug << page.parent.url.to_s
    else
      complete_slug = "#{self.locale}"
    end
    complete_slug << "/#{self.slug}"
    self.url = complete_slug
  end
  
  def create_slug
    if title.present? && slug.blank?
      write_attribute(:slug, read_attribute(:title).downcase.parameterize)
    end
  end
end