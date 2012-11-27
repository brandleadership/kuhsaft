module Kuhsaft
  class Brick < ActiveRecord::Base

    belongs_to :page
    attr_accessible :locale, :position, :type

    default_scope order('position ASC')
    scope :localized, lambda { where(:locale => I18n.locale) }
    acts_as_taggable

    def edit_partial_path
      path = self.class.model_name.to_partial_path.split '/'
      path << "edit_#{path.pop}"
      path.join '/'
    end

    def siblings
      self.page.bricks.where('id !=?', self.id) if self.page.present?
    end

    def show_partial_path
      path = self.class.model_name.to_partial_path.split '/'
      path << "show_#{path.pop}"
      path.join '/'
    end

    def fulltext
      #raise NotImplementedError
      ""
    end
  end
end
