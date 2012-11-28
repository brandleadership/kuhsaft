module Kuhsaft
  class Brick < ActiveRecord::Base

    belongs_to :page
    belongs_to :parent, :class_name => 'Kuhsaft::Brick', :foreign_key => :parent_id
    has_many :bricks, :class_name => 'Kuhsaft::Brick', :dependent => :destroy
    attr_accessible :locale, :position, :type, :parent_id, :page_id, :page, :parent

    default_scope order('position ASC')
    scope :localized, lambda { where(:locale => I18n.locale) }
    acts_as_taggable

    def to_edit_partial_path
      path = self.to_partial_path.split '/'
      path << "edit_#{path.pop}"
      path.join '/'
    end

    def siblings
      self.page.bricks.where('id !=?', self.id) if self.page.present?
    end

    def fulltext
      #raise NotImplementedError
      ""
    end
  end
end
