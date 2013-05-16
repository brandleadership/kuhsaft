require 'active_support/concern'
require 'textacular/searchable'

module Kuhsaft
  module Searchable
    extend ActiveSupport::Concern

    included do
      if ActiveRecord::Base.connection.instance_values['config'][:adapter] == 'postgresql'
        extend Searchable
      else
        scope :search, lambda { |attr|
          if attr.is_a? Hash
            where("#{attr.first[0]} LIKE ?", "%#{attr.first[1]}%")
          else
            where("#{locale_attr(:fulltext)} LIKE ?", "%#{attr}%")
          end
        }
      end
    end
  end
end
