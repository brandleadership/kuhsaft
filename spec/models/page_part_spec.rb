require 'spec_helper'

describe Kuhsaft::PagePart do
  context 'knows its page part types' do
    it 'keeps known page parts as an array' do
      Kuhsaft::PagePart.all.should be_a Array
    end

    it 'references page part types as symbols' do
      Kuhsaft::PagePart.all.should be_all { |p| p.should be_a Symbol }
    end

    it 'can load the corresponding modules' do
      lambda { Kuhsaft::PagePart.all.each { |p| p.to_s.camelize.constantize } }.should_not raise_error NameError
    end
  end
end
