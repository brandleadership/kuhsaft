module Kuhsaft
  module Orderable
    def increment_position
      update_attribute :position, position + 1
    end
  
    def decrement_position
      update_attribute :position, position - 1
    end
  
    def preceding_sibling
      siblings.where('position = ?', position - 1).first
    end
  
    def succeeding_sibling
      siblings.where('position = ?', position + 1).first
    end
  
    def preceding_siblings
      siblings.where('position <= ?', position).where('id != ?', id)
    end
  
    def succeeding_siblings
      siblings.where('position >= ?', position).where('id != ?', id)
    end
  
    def position_to_top
      update_attribute :position, 1
      recount_siblings_position_from 1
    end
  
    def recount_siblings_position_from position
      counter = position
      succeeding_siblings.each { |s| counter += 1; s.update_attribute(:position, counter) }
    end
  
    def reposition before_id
      if before_id.blank?
        position_to_top
      else
        update_attribute :position, self.class.position_of(before_id) + 1
        recount_siblings_position_from position
      end
    end
  
    def set_position
      update_attribute(:position, siblings.count + 1)
    end
  end
end