class Kuhsaft::Page < ActiveRecord::Base
  has_many :localized_pages
  has_many :childs, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Kuhsaft::Page', :foreign_key => :parent_id
  
  scope :root_pages, where('parent_id IS NULL').order('position ASC')
  
  def root?
    parent.nil?
  end
end