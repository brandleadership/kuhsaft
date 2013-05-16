require 'active_support/concern'
require 'textacular/searchable'

module Kuhsaft
  module Searchable
    extend ActiveSupport::Concern

    included do
      if ActiveRecord::Base.connection.instance_values['config'][:adapter] == 'postgresql'
        extend Searchable
      else
        scope :search, lambda { |kv|
          where("#{kv.first[0]} LIKE ?", "%#{kv.first[1]}%")
        }
      end
    end
  end
end
