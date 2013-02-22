module Kuhsaft
  class BrickType < ActiveRecord::Base
    attr_accessible :disabled, :class_name, :group
    scope :grouped, order('`group`, `id` asc')
    scope :enabled, where('disabled IS NOT false')
    scope :constrained, lambda { |list| where(:type => list) }
  end
end
