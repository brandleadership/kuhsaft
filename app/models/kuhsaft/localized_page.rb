class Kuhsaft::LocalizedPage < ActiveRecord::Base
  belongs_to :page
  has_many :page_parts, :class_name => 'Kuhsaft::PagePart::Content', :autosave => true

  scope :current_locale, lambda{ where('locale = ?', Kuhsaft::Page.current_translation_locale) }
  
  scope :published, lambda{ 
    where('published = ? OR published_at < ? AND published = ?', 
      Kuhsaft::PublishState::PUBLISHED, 
      DateTime.now, 
      Kuhsaft::PublishState::PUBLISHED_AT
    )
  }
  
  scope :search, lambda{ |term| current_locale.published.where('fulltext LIKE ?', "%#{term}%") }
  scope :navigation, lambda{ |slug| current_locale.published.where('slug = ?', slug) }
  
  before_validation :create_slug, :create_url, :collect_fulltext
  delegate :childs, :to => :page
  
  validates :title, :presence => true
  validates :locale, :presence => true
  validates :slug, :presence => true, :uniqueness => true, :unless => :allow_empty_slug
  validates :slug, :uniqueness => true
  
  accepts_nested_attributes_for :page_parts, :allow_destroy => true
  
  def published?
    return true if published == Kuhsaft::PublishState::PUBLISHED
    return false if published == Kuhsaft::PublishState::UNPUBLISHED
    if published == Kuhsaft::PublishState::PUBLISHED_AT
      return false if published_at.blank?
      published_at < DateTime.now
    else
      false
    end
  end
  
  def locale
    read_attribute(:locale).to_sym unless read_attribute(:locale).nil?
  end
  
  def redirect?
    page_type == Kuhsaft::PageType::REDIRECT
  end
  
  def navigation?
    page_type == Kuhsaft::PageType::NAVIGATION
  end
  
  def create_url
    return if self.page_type == Kuhsaft::PageType::REDIRECT
    complete_slug = ''
    if page.present? && page.parent.present?
      complete_slug << page.parent.url.to_s
    else
      complete_slug = "#{self.locale}"
    end
    complete_slug << "/#{self.slug}" unless self.page_type == Kuhsaft::PageType::NAVIGATION
    self.url = complete_slug
  end
  
  def create_slug
    has_slug = title.present? && slug.blank?
    write_attribute(:slug, read_attribute(:title).downcase.parameterize) if has_slug
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
  
  def allow_empty_slug
    self.page_type == Kuhsaft::PageType::NAVIGATION
  end
end