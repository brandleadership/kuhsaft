class Kuhsaft::Page < ActiveRecord::Base
  include Kuhsaft::Orderable
  
  has_many :localized_pages, :dependent => :destroy
  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  
  scope :root_pages, where('parent_id IS NULL')
  default_scope order('position ASC')
  
  delegate  :title, :slug, :published, :published?, :page_type, :keywords, :description, :locale, :body, :url, :fulltext,
            :to => :translation, :allow_nil => true
  
  accepts_nested_attributes_for :localized_pages
  
  after_save :save_translation
  after_create :set_position
  
  #
  # Stores the selected type of page_part when created through the form
  #
  attr_accessor :page_part_type
  
  def root?
    parent.nil?
  end
  
  def parent_pages
    parent_pages_list = []
    parent = self
    
    while parent
      parent_pages_list << parent unless parent.translation.page_type == Kuhsaft::PageType::NAVIGATION
      parent = parent.parent
    end
    parent_pages_list.reverse
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
      child.translation.save if child.translation.persisted?
    end
  end
  
  def link
    if translation.page_parts.count == 0 && childs.count > 0
      childs.first.link
    else
      if translation.page_type == Kuhsaft::PageType::REDIRECT
        url
      else
        "/#{url}"
      end
    end
  end
  
  class << self
    def position_of id
      Kuhsaft::Page.find(id).position rescue 1
    end
    
    def find_by_url url
      translation = Kuhsaft::LocalizedPage.where('url = ?', url)
      translation.present? && translation.first.present? ? translation.first.page : nil
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
  end
end