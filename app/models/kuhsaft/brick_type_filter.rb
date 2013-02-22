
module Kuhsaft
  class BrickTypeFilter < SimpleDelegator


    def empty?
      !(respond_to?(:user_can_add_childs?) && user_can_add_childs? && !allowed.empty?)
    end

    def allowed
      if Kuhsaft::BrickType.count.zero?
        []
      elsif allowed_brick_types.empty?
        Kuhsaft::BrickType.all
      else
        Kuhsaft::BrickType.constrained(allowed_brick_types)
      end
    end

  end
end
