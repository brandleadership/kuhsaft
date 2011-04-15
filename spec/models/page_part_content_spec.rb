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
      
      it 'should have a list of page_part_types' do
        Kuhsaft::PagePart::Content.page_part_types.should be_all { |p| p.superclass.should eq Kuhsaft::PagePart::Content }
      end
      
      it 'should have the Markdown PagePart by default' do
        Kuhsaft::PagePart::Content.subclasses.should include(Kuhsaft::PagePart::Markdown)
      end
      
      it 'should map subclasses to strings' do
        Kuhsaft::PagePart::Content.key_for_class(Kuhsaft::PagePart::Markdown).should eq('kuhsaft.page_part.markdown')
      end
      
      it 'should map strings to subclasses' do
        Kuhsaft::PagePart::Content.class_for_key('kuhsaft.page_part.markdown').should be(Kuhsaft::PagePart::Markdown)
      end
      
      it 'should convert to_name' do
        Kuhsaft::PagePart::Markdown.to_name.should eq('Markdown')
      end
      
      it 'should convert to_key' do
        Kuhsaft::PagePart::Markdown.to_key.should eq('kuhsaft.page_part.markdown')
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