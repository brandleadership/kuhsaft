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
    
    it 'should be orderable' do
      @content.should respond_to(:position)
    end
    
    it 'should have tags' do
      @content.should respond_to(:tags)
    end
    
    it 'should have a tag list' do
      @content.should respond_to(:tag_list)
    end
    
    context 'class' do
      it 'should keep a list of the serializeable attributes' do
        Kuhsaft::PagePart::Content.serializeable_attributes.should be_a(Array)
      end
      
      it 'should return the position of a page_part' do
        Kuhsaft::PagePart::Content.should respond_to(:position_of)
      end
      
      it 'should keep a list of searchable attributes' do
        Kuhsaft::PagePart::Content.searchable_attributes.should be_a(Array)
      end
      
      it 'should have a list of page_part_types' do
        Kuhsaft::PagePart::Content.page_part_types.should be_all { |p| p.superclass.should eq Kuhsaft::PagePart::Content }
      end
      
      it 'should have the Markdown PagePart by default' do
        Kuhsaft::PagePart::Content.descendants.should include(Kuhsaft::PagePart::Markdown)
      end
    end
  end
  
  describe 'Markdown' do
    before do
      @m = Kuhsaft::PagePart::Markdown.new
    end
    
    it 'should have text' do
      @m.should respond_to(:text)
    end
    
    it 'should have searchable text' do
      Kuhsaft::PagePart::Markdown.searchable_attributes.should include(:text)
    end
    
    it 'should store text' do
      @m.text = 'hi'
      @m.text.should eq('hi')
    end
    
    it 'should restore the serialized attributes when loaded' do
      m = Kuhsaft::PagePart::Markdown.create(:text => 'hi')
      m2 = Kuhsaft::PagePart::Markdown.find(m.id)
      m2.text.should eq('hi')
    end
    
    describe 'edit_partial_path' do
      it 'should return kuhsaft/page_part/markdowns/edit_markdown' do
        @m.edit_partial_path.should eq('kuhsaft/page_part/markdowns/edit_markdown')
      end
    end
    
    describe 'show_partial_path' do
      it 'should return kuhsaft/page_part/markdowns/show_markdown' do
        @m.show_partial_path.should eq('kuhsaft/page_part/markdowns/show_markdown')
      end
    end
  end
end