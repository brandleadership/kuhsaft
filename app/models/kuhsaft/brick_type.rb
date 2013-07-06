module Kuhsaft
  class BrickType < ActiveRecord::Base
    attr_accessible :disabled, :class_name, :group
    scope :grouped, -> { order('`group`, `id` asc') }
    scope :enabled, -> { where(:enabled => true) }
    scope :constrained, ->(list) { where(:class_name => list) }
  end
end
