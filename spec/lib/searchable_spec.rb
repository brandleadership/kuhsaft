require 'spec_helper'

describe Kuhsaft::Searchable do

  class Demo
  end

  context 'without postgresql' do
    it 'initializes scope' do
      ActiveRecord::Base.connection.instance_values.should_not == 'postgresql'
      Demo.should_receive :scope
      Demo.class_eval do
        include Kuhsaft::Searchable
      end
    end
  end 
end
