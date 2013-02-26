module Kuhsaft
  class BrickType < ActiveRecord::Base
    attr_accessible :disabled, :class_name, :group
    scope :grouped, order('`group`, `id` asc')
    scope :enabled, where('disabled != ?', false)
    scope :constrained, lambda { |list| where(:class_name => list) }
  end
end
