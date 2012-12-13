module Kuhsaft
  class BrickType < ActiveRecord::Base
    attr_accessible :disabled, :class_name, :group
    scope :by_group, order('group, id')
  end
end
