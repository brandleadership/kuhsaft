require 'spec_helper'

describe Kuhsaft::PagePart::Content do
  
  before :each do 
    @page_part = Factory.build :page_part
  end
  
  it 'should serialize it\'s content when saved' do
    @page_part.content.should_receive(:to_yaml)
    @page_part.save
  end
  
  it 'should deserialize it\'s content when loaded' do
    @page_part.save
    @page_part.content.should be_a(Kuhsaft::PagePart::Base)
  end
  
  it 'should have a text in the default markdown PagePart' do
    @page_part.content.text.should == 'h1. Hello world!'
  end
end
