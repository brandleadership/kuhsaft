require 'spec_helper'

describe CmsHelper do
  context 'when the user creates a toplevel page' do
    describe '#available_parent_pages' do
      it 'should return the 2 pages' do
        helper.available_parent_pages.should have(2).pages
      end
    end  
  end
  
  describe '#available_parent_pages' do
    before do
      page1, page2, page3 = create_page_tree
      helper.stub!(:params).and_return(:parent_id => page3.id)
    end    
    
    it 'should return the parent pages' do
      helper.available_parent_pages.should have_at_least(3).pages
    end
  end
end