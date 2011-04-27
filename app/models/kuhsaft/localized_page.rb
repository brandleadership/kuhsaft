class Kuhsaft::LocalizedPage < ActiveRecord::Base
  belongs_to :page
  has_many :page_parts, :class_name => 'Kuhsaft::PagePart::Content', :autosave => true
  scope :search, lambda{ |term| where('fulltext LIKE ?', "%#{term}%") }
  
  before_validation :create_slug, :create_url, :collect_fulltext
  delegate :childs, :to => :page
  
  validates :title, :presence => true
  validates :locale, :presence => true
  validates :slug, :presence => true
  
  accepts_nested_attributes_for :page_parts, :allow_destroy => true
  
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
  
  def collect_fulltext
    self.fulltext = page_parts.inject('') do |text, page_part|
      page_part.class.searchable_attributes.each do |attr|
        text << ' '
        text << page_part.send(attr).to_s
      end
      text
    end
    self.fulltext << [title.to_s, keywords.to_s, description.to_s].join(' ')
  end
end