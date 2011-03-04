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
            :to => :localized_page
  
  after_save :save_localized_page
  
  def root?
    parent.nil?
  end
  
  def localized_page
    @localized_page ||= localized_pages.where('locale = ?', I18n.locale).first
    @localized_page ||= localized_pages.build :locale => I18n.locale
  end
  
  def save_localized_page
    localized_page.save unless localized_page.blank?
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
    preceding_siblings.last
  end
  
  def succeeding_sibling
    succeeding_siblings.first
  end
  
  def preceding_siblings
    siblings.positioned.where('position < ?', position)
  end
  
  def succeeding_siblings
    siblings.positioned.where('position > ?', position)
  end
  
  def position_to_top
    succeeding_siblings.update_all('position = position + 1')
    update_attribute :position, 0
  end
  
  def reposition before_id
    if before_id.blank?
      position_to_top
    else
      preceding_page = Kuhsaft::Page.find(before_id)
      update_attribute :position, preceding_page.position
      preceding_page.preceding_siblings.each { |s| s.decrement_position }
      succeeding_siblings.each { |s| s.increment_position }
    end
  end
  
  def self.position_of id
    Kuhsaft::Page.find(id).position rescue 0
  end
end