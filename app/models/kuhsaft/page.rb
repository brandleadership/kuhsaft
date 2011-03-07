class Kuhsaft::Page < ActiveRecord::Base
  has_many :localized_pages
  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  
  scope :root_pages, where('parent_id IS NULL')
  scope :positioned, order('position ASC')
  
  delegate  :title, :title=, 
            :slug, :slug=, 
            :published, :published=, 
            :keywords, :keywords=, 
            :description, :description=, 
            :locale, :locale=,
            :body, :body=,
            :to => :translation
  
  after_save :save_translation
  after_create :set_position
  
  def root?
    parent.nil?
  end
  
  def localized_page
    translation
  end
  
  def translation
    @localized_page ||= localized_pages.where('locale = ?', Kuhsaft::Page.current_translation_locale).first
    @localized_page ||= localized_pages.build :locale => Kuhsaft::Page.current_translation_locale
  end
  
  def save_translation
    @localized_page.save unless @localized_page.blank?
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
    siblings.positioned.where('position <= ?', position).where('id != ?', id)
  end
  
  def succeeding_siblings
    siblings.positioned.where('position >= ?', position).where('id != ?', id)
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
      update_attribute :position, self.class.position_of(before_id)
      recount_siblings_position_from position
    end
  end
  
  def set_position
    update_attribute(:position, siblings.count + 1)
  end
  
  class << self
    def position_of id
      Kuhsaft::Page.find(id).position rescue 0
    end
    
    def translation_locales
      @translation_locales ||= [:en]
    end
    
    def translation_locales=(array)
      @translation_locales = array.map(&:to_sym)
    end
    
    def current_translation_locale
      @translation_locale ||= translation_locales.first
    end
    
    def current_translation_locale=(locale)
      @translation_locale = locale.to_sym
    end
  end
end