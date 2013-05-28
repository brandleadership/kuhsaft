require 'active_support/concern'
require 'pg_search'

module Kuhsaft
  module Searchable
    extend ActiveSupport::Concern

    included do
      if ActiveRecord::Base.connection.instance_values['config'][:adapter] == 'postgresql'
        include ::PgSearch
        cb = lambda do |query|
          {
            :against => {
              locale_attr(:title)       => 'A',
              locale_attr(:keywords)    => 'B',
              locale_attr(:description) => 'C',
              locale_attr(:fulltext)    => 'C',
            },
            :query => query,
            :using => { :tsearch => { :dictionary => 'english' }}
          }
        end
        pg_search_scope :search, cb
      else
        scope :search, lambda { |query|
          if query.is_a? Hash
            where("#{query.first[0]} LIKE ?", "%#{query.first[1]}%")
          else
            where("#{locale_attr(:fulltext)} LIKE ?", "%#{query}%")
          end
        }
      end
    end
  end
end
