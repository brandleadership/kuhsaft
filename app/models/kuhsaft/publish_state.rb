module Kuhsaft
  class PublishState
    
    extend ActiveModel::Translation
    
    UNPUBLISHED = 0
    PUBLISHED = 1
    PUBLISHED_AT = 2
    
    attr_reader :name
    attr_reader :value
    
    def initialize options
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) if respond_to?(k) }
    end

    def self.all
      @all ||= [
        PublishState.new(:name => 'published', :value => PUBLISHED),
        PublishState.new(:name => 'unpublished', :value => UNPUBLISHED),
        PublishState.new(:name => 'published_at', :value => PUBLISHED_AT)
        ]
    end
  end
end