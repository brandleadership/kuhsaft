class Kuhsaft::Page < ActiveRecord::Base
  include Kuhsaft::Orderable
  
  has_many :localized_pages, :dependent => :destroy
  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  
  scope :published, lambda {
    includes(:localized_pages).where('localized_pages.published = ? OR localized_pages.published_at < ? AND localized_pages.published = ?', 
      Kuhsaft::PublishState::PUBLISHED, 
      DateTime.now, 
      Kuhsaft::PublishState::PUBLISHED_AT
    )
  }
  
  scope :current_locale, lambda {
    includes(:localized_pages).where('localized_pages.locale = ?', Kuhsaft::Page.current_translation_locale)
  }
  
  scope :root_pages, where('parent_id IS NULL')
  default_scope order('position ASC')
  
  delegate  :title, :slug, :published, :published?, :page_type, :keywords, :description, 
            :locale, :body, :url, :fulltext, :page_parts, :redirect?, :navigation?,
            :to => :translation, :allow_nil => true

  accepts_nested_attributes_for :localized_pages

  after_save :save_translation

  #
  # Stores the selected type of page_part when created through the form
  #
  attr_accessor :page_part_type

  def root?
    parent.nil?
  end

  def without_self
    Kuhsaft::Page.where('id != ?', self.id)
  end

  def parent_pages
    parent_pages_list = []
    parent = self

    while parent
      parent_pages_list << parent unless parent.translation.blank? || parent.translation.navigation?
      parent = parent.parent
    end
    parent_pages_list.reverse
  end
  
  def siblings
    (parent.present? ? parent.childs : Kuhsaft::Page.root_pages).where('id != ?', id)
  end
  
  def translation lang = nil
    lang ||= Kuhsaft::Page.current_translation_locale
    @translation = localized_pages.where('locale = ?', lang).first if @translation.blank? || @translation.locale != lang
    @translation
  end
  
  def save_translation
    unless @translation.blank?
      @translation.save 
    end
    childs.each do |child|
      child.translation.save if child.translation.present? && child.translation.persisted?
    end
  end
  
  def link
    if translation.present? && translation.page_parts.count == 0 && childs.count > 0
      childs.first.link
    else
      if translation.present? && translation.redirect?
        url
      else
        "/#{url}"
      end
    end
  end
  
  def nesting_name
    num_dashes = parent_pages.size - 1
    num_dashes = 0 if num_dashes < 0
    "#{'-' * num_dashes} #{self.title}".strip
  end
  
  class << self
    def find_by_url url
      translation = Kuhsaft::LocalizedPage.published.where('url = ?', url)
      if translation.present? && translation.first.present?
        page = translation.first.page
        page.translation(translation.first.locale)
        page
      else
        nil
      end
    end
    
    def translation_locales
      @translation_locales
    end
    
    def translation_locales=(array)
      @translation_locales = array.map(&:to_sym) if array.class == Array
    end
    
    def current_translation_locale
      @translation_locale ||= translation_locales.first
    end
    
    def current_translation_locale=(locale)
      @translation_locale = locale.to_sym
      I18n.locale = @translation_locale if I18n.available_locales.include?(@translation_locale)
    end
    
    def flat_tree pages= nil
      pages ||= Kuhsaft::Page.root_pages
      list ||= []
      pages.each do |page|
        list << page
        flat_tree(page.childs).each { |p| list << p } if page.childs.count > 0
      end
      list
    end
  end
end