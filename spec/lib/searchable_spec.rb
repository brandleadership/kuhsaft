require 'spec_helper'

describe Kuhsaft::Searchable do

  context 'with missing includes' do
    it 'raises exteption when class does not include Kuhsaft::Bricklist' do
      expect {
        class Foo
          include Kuhsaft::Searchable
        end
      }.to raise_error(/needs Kuhsaft::BrickList to be included/)
    end
  end

  context 'with Bricklist included' do
    class SearchableDemo < ActiveRecord::Base
      include Kuhsaft::BrickList
    end

    context 'without postgresql' do
      it 'initializes scope' do
        ActiveRecord::Base.connection.instance_values.should_not == 'postgresql'
        SearchableDemo.should_receive :scope
        SearchableDemo.class_eval do
          include Kuhsaft::Searchable
        end
      end
    end
  end 
end
