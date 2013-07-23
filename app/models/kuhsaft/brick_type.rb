module Kuhsaft
  class BrickType < ActiveRecord::Base
    scope :grouped, -> { order('`group`, `id` asc') }
    scope :enabled, -> { where(:enabled => true) }
    scope :constrained, ->(list) { where(:class_name => list) }
  end
end
