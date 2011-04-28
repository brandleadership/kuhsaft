class Kuhsaft::Page < ActiveRecord::Base
  has_many :localized_pages, :dependent => :destroy
  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  
  scope :root_pages, where('parent_id IS NULL')
  default_scope order('position ASC')
  
  delegate  :title, :slug, :published, :keywords, :description, :locale, :body, :url, :fulltext,
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
  
  def increment_position
    update_attribute :position, position + 1
  end
  
  def decrement_position
    update_attribute :position, position - 1
  end
  
  def siblings
    (parent.present? ? parent.childs : Kuhsaft::Page.root_pages).where('id != ?', id)
  end
  
  def preceding_sibling
    siblings.where('position = ?', position - 1).first
  end
  
  def succeeding_sibling
    siblings.where('position = ?', position + 1).first
  end
  
  def preceding_siblings
    siblings.where('position <= ?', position).where('id != ?', id)
  end
  
  def succeeding_siblings
    siblings.where('position >= ?', position).where('id != ?', id)
  end
  
  def position_to_top
    update_attribute :position, 1
    recount_siblings_position_from 1
  end
  
  def recount_siblings_position_from position
    counter = position
    succeeding_siblings.each { |s| counter += 1; s.update_attribute(:position, counter) }
  end
  
  def reposition before_id
    if before_id.blank?
      position_to_top
    else
      update_attribute :position, self.class.position_of(before_id) + 1
      recount_siblings_position_from position
    end
  end
  
  def set_position
    update_attribute(:position, siblings.count + 1)
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