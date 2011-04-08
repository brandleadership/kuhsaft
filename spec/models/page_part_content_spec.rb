require 'spec_helper'

describe 'PagePart' do
  
  describe 'Content' do
    before do
      @content = Kuhsaft::PagePart::Content.new
    end
    
    it 'should belong to a LocalizedPage' do
      @content.should respond_to(:localized_page)
    end
    
    it 'should have a content to store serialized data' do
      @content.should respond_to(:content)
    end
    
    context 'class' do
      it 'should keep a list of the serializeable attributes' do
        Kuhsaft::PagePart::Content.serializeable_attributes.should be_a(Array)
      end
    end
  end
  
  describe 'Markdown' do
    before do
      @m = Kuhsaft::PagePart::Markdown.new
    end
    
    it 'should store text' do
      @m.should respond_to(:text)
    end
    
    it 'should collect the serializeable attributes to be saved' do
      @m.text = 'hi'
      @m.should_receive(:collect_serializeable_attributes).and_return([[:text, 'hi']])
      @m.save
    end
    
    it 'should restore the serialized attributes when loaded' do
      m = Kuhsaft::PagePart::Markdown.create(:text => 'hi')
      m2 = Kuhsaft::PagePart::Markdown.find(m.id)
      m2.text.should eq('hi')
    end
  end
end