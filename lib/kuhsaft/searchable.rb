require 'active_support/concern'
require 'pg_search'

module Kuhsaft
  module Searchable
    extend ActiveSupport::Concern

    DICTIONARIES = {
      :en => 'english',
      :de => 'german',
    }

    def update_fulltext
      self.fulltext = collect_fulltext
    end

    included do
      unless included_modules.include?(BrickList)
        raise 'Kuhsaft::Searchable needs Kuhsaft::BrickList to be included'
      end

      if included_modules.include?(Translatable)
        translate :fulltext
      else
        attr_accessible :fulltext
      end

      before_validation :update_fulltext

      if ActiveRecord::Base.connection.instance_values['config'][:adapter] == 'postgresql'
        include ::PgSearch
        cb = lambda do |query|
          {
            :against => {
              locale_attr(:navigation_name) => 'A',
              locale_attr(:title)           => 'A',
              locale_attr(:keywords)        => 'B',
              locale_attr(:description)     => 'C',
              locale_attr(:fulltext)        => 'C',
            },
            :query => query,
            :using => { :tsearch => { :dictionary => DICTIONARIES[I18n.locale] || 'simple' }}
          }
        end
        pg_search_scope :search_without_excerpt, cb
        scope :search, lambda { |query|
          ts_headline = sanitize_sql_array([
            "ts_headline(%s, plainto_tsquery('%s')) AS excerpt",
            locale_attr(:fulltext),
            query
          ])
          search_without_excerpt(query).select(ts_headline)
        }
      else
        # TODO: Tests run in this branch because dummy app uses mysql. Change it!
        # define empty fallback excerpt attribute
        attr_reader :excerpt
        scope :search, lambda { |query|
          if query.is_a? Hash
            where("#{query.first[0]} LIKE ?", "%#{query.first[1]}%")
          else
            stmt = ""
            stmt += "#{locale_attr(:keywords)} LIKE ? OR "
            stmt += "#{locale_attr(:navigation_name)} LIKE ? OR "
            stmt += "#{locale_attr(:title)} LIKE ? OR "
            stmt += "#{locale_attr(:description)} LIKE ? OR "
            stmt += "#{locale_attr(:fulltext)} LIKE ?"
            where(stmt, *(["%#{query}%"] * 5))
          end
        }
      end
    end
  end
end
