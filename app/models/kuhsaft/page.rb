class Kuhsaft::Page < ActiveRecord::Base
  include Kuhsaft::Orderable
  include Kuhsaft::Translatable

  translate :title, :slug, :keywords, :description, :body, :url, :fulltext
  attr_accessible :title, :slug, :url, :page_type, :parent_id, :keywords, :description, :published

  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  has_many :bricks, :class_name => 'Kuhsaft::Brick', :dependent => :destroy
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id

  default_scope order('position ASC')

  scope :root_pages, where('parent_id IS NULL')
  scope :published, where(:published => Kuhsaft::PublishState::PUBLISHED)
  scope :search, lambda{ |term| published.where("`#{locale_attr(:fulltext)}` LIKE ?", "%#{term}%") }
  scope :navigation, lambda{ |slug| where(locale_attr(:slug) => slug).where(locale_attr(:page_type) => Kuhsaft::PageType::NAVIGATION) }

  before_validation :create_slug, :create_url, :collect_fulltext

  validates :title, :presence => true
  validates :slug, :presence => true
  #validates :url, :uniqueness => true, :unless => :navigation?

  accepts_nested_attributes_for :bricks, :allow_destroy => true


  #
  # Stores the selected type of page_part when created through the form
  #

  attr_accessor :page_part_type

  class << self
    def flat_tree(pages = nil)
      pages ||= Kuhsaft::Page.root_pages
      list ||= []
      pages.each do |page|
        list << page
        flat_tree(page.childs).each { |p| list << p } if page.childs.count > 0
      end
      list
    end

    def find_by_url(url)
      send "find_by_#{locale_attr(:url)}", url
    end
  end

  def root?
    parent.nil?
  end

  def without_self
    Kuhsaft::Page.where('id != ?', self.id)
  end

  def published?
    published == Kuhsaft::PublishState::PUBLISHED
  end

  def redirect?
    page_type == Kuhsaft::PageType::REDIRECT
  end

  def navigation?
    page_type == Kuhsaft::PageType::NAVIGATION
  end

  def parent_pages
    parents = []
    parent = self

    while parent
      parents << parent unless parent.navigation?
      parent = parent.parent
    end
    parents.reverse
  end

  def siblings
    (parent.present? ? parent.childs : Kuhsaft::Page.root_pages).where('id != ?', id)
  end

  def link
    if bricks.count == 0 && childs.count > 0
      childs.first.link
    else
      if redirect?
        url
      else
        "/#{url}"
      end
    end
  end

  def create_url
    return if redirect?

    complete_slug = ''
    if parent.present?
      complete_slug << parent.url.to_s
    else
      complete_slug = "#{I18n.locale}"
    end
    complete_slug << "/#{self.slug}" unless navigation?
    self.url = complete_slug
  end

  def create_slug
    has_slug = title.present? && slug.blank?
    self.slug = title.downcase.parameterize if has_slug
  end

  def collect_fulltext
    self.fulltext = bricks.localized.inject('') do |text, brick|
      text << brick.fulltext
      text
    end
    self.fulltext = self.fulltext + [title.to_s, keywords.to_s, description.to_s].join(' ')
  end

  def nesting_name
    num_dashes = parent_pages.size - 1
    num_dashes = 0 if num_dashes < 0
    "#{'-' * num_dashes} #{self.title}".strip
  end

end
