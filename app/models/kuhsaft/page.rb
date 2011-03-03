class Kuhsaft::Page < ActiveRecord::Base
  has_many :localized_pages
  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  
  scope :root_pages, where('parent_id IS NULL').order('position ASC')
  delegate :title, :slug, :published, :keywords, :description, :to => :localized_page
  
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
end