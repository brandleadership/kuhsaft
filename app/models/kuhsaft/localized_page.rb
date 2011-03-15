class Kuhsaft::LocalizedPage < ActiveRecord::Base
  belongs_to :page
  has_many :page_parts, :class_name => 'Kuhsaft::PagePart::Content'
  before_validation :create_slug
  
  delegate :childs, :to => :page
  
  validates :title, :presence => true
  validates :locale, :presence => true
  validates :slug, :presence => true
  
  def locale
    read_attribute(:locale).to_sym unless read_attribute(:locale).nil?
  end
  
  def create_slug
    if title.present? && slug.blank?
      write_attribute(:slug, read_attribute(:title).downcase.parameterize)
    end
  end
end