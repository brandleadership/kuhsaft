class Kuhsaft::Page < ActiveRecord::Base
  include Kuhsaft::Orderable
  include Kuhsaft::Translatable
  include Kuhsaft::BrickList

  has_ancestry
  acts_as_brick_list

  translate :title, :slug, :keywords, :description, :body, :url, :fulltext
  attr_accessible :title, :slug, :url, :page_type, :parent_id, :keywords, :description, :published

  default_scope order('position ASC')

  scope :published, where(:published => Kuhsaft::PublishState::PUBLISHED)
  scope :search, lambda{ |term| published.where("`#{locale_attr(:fulltext)}` LIKE ?", "%#{term}%") }
  scope :navigation, lambda{ |slug| where(locale_attr(:slug) => slug).where(locale_attr(:page_type) => Kuhsaft::PageType::NAVIGATION) }

  before_validation :create_slug, :create_url, :collect_fulltext

  validates :title, :presence => true
  validates :slug, :presence => true
  #validates :url, :uniqueness => true, :unless => :navigation?


  class << self
    def flat_tree(pages = nil)
      # pages ||= Kuhsaft::Page.root_pages
      # list ||= []
      # pages.each do |page|
      #   list << page
      #   flat_tree(page.children).each { |p| list << p } if page.children.count > 0
      # end
      # list
      arrange_as_array
    end

    def arrange_as_array(options={}, hash=nil)
      hash ||= arrange(options)

      arr = []
      hash.each do |node, children|
        arr << node
        arr += arrange_as_array(options, children) unless children.empty?
      end

      arr
    end

    def find_by_url(url)
      send "find_by_#{locale_attr(:url)}", url
    end

    def root_pages
      roots
    end
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
    ancestors
  end

  def link
    if bricks.count == 0 && children.count > 0
      children.first.link
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
    num_dashes = parent_pages.size
    num_dashes = 0 if num_dashes < 0
    "#{'-' * num_dashes} #{self.title}".strip
  end

  def brick_list_type
    'Kuhsaft::Page'
  end
end
