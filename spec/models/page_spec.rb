require 'spec_helper'

describe Kuhsaft::Page do
  
  before do
    set_lang :en
  end
  
  after do
    reset_lang
  end
  
  before :each do 
    destroy_all_pages
    @page = Factory.create :page
  end
  
  describe 'associations' do
    describe '#localized_pages' do
      it 'should have localized_pages' do
        @page.should respond_to(:localized_pages)
      end
      
      it 'should have at least 1 localized page' do
        @page.localized_pages.should have_at_least(1).item
      end
    end
    
    describe '#childs' do
      it 'should have child pages' do
        @page.childs << Factory.create(:page)
        @page.childs.should have_at_least(1).page
      end
    end
  end
  
  describe 'class methods' do
    describe '#root_pages' do
      before { destroy_all_pages }            
      it 'should have a list of the toplevel pages' do
        root_page = Factory.create :page
        Kuhsaft::Page.root_pages.should have_at_least(1).page
      end
    end
    
    describe '#position_of' do
      it 'should find the position of a page' do
        page = Factory.create :page
        position = page.position
        Kuhsaft::Page.position_of(page.id).should == position
      end
    end
    
    describe '#find_by_url' do
      before { destroy_all_pages }
      it 'should find its translated content by url' do
        page = Factory.create(:page)
        Kuhsaft::Page.find_by_url(page.url).should eq(page)
      end
    end
    
    describe 'languages and locales' do
      describe '#translation_locales' do
        it 'should provide an array of translation locales' do
          Kuhsaft::Page.translation_locales.should be_an_instance_of(Array)
        end
        
        it 'should contain :en as minimal translation locale' do
          Kuhsaft::Page.translation_locales.include?(:en).should be_true
        end
        
        it 'should contain only locale symbols' do
          Kuhsaft::Page.translation_locales = ['de']
          Kuhsaft::Page.translation_locales.should be_all { |l| l.should be_an_instance_of(Symbol)}
        end
      end
      
      describe '#current_translation_locale' do
        it 'should have the current translation locale' do
          Kuhsaft::Page.current_translation_locale = 'de'
          Kuhsaft::Page.current_translation_locale.should be(:de)
        end
      end
    end
  end
  
  describe 'instance methods' do
    describe '#root?' do
      it 'should return true for a page without a parent' do
        Factory::create(:page).root?.should be_true
      end
    end
    
    describe '#parent' do
      before do
        @page = Factory::create :page
        @child = Factory::create :page
        @page.childs << @child
      end
      
      it 'should know it\'s parent page' do
        @child.should respond_to(:parent)
      end
      
      it 'should be a Kuhsaft::Page' do
        @child.parent.should be_an_instance_of(Kuhsaft::Page)
      end
    end
    
    describe '#translation' do
      it 'should have a translation' do
        @page.should respond_to(:translation)
      end
      
      it 'should return a Kuhsaft::LocalizedPage' do
        @page.translation.should be_an_instance_of(Kuhsaft::LocalizedPage)
      end
      
      context 'when saving the page' do
        it 'should save the translation' do
          @page.translation.title = 'some localized title'
          @page.should_receive(:save_translation)
          @page.save
        end
      end
    end
    
    describe '#page_part_type' do
      it 'accepts a page_part_type to determine which page_part needs to be added' do
        @page.should respond_to(:page_part_type)
      end
    end
    
    describe '#parent_pages' do
      it 'should have parent_pages' do
        @page.should respond_to(:parent_pages)
      end
    
      it 'should have a list of parent pages' do
        @page.parent_pages.should be_instance_of(Array)
      end
    
      it 'should be ordered from top to bottom' do
        @page.parent_pages.last.should be(@page)
      end
    end
    
    describe '#link' do
      it 'should have a link' do
        @page.should respond_to(:link)
      end
      
      context 'when it has no content' do
        it 'should return the link of it\'s first child' do
          page = Factory.create :page
          child = Factory.create :page
          page.childs << child
          page.translation.body = nil
          page.save
          page.link.should == child.link
        end
      end
    end
  end
  
  describe 'custom ordering' do
    describe '#increment_position' do
      it 'should increment it\'s position by 1' do
        page = Factory.create :page
        position = page.position
        page.increment_position
        page.position.should == (position + 1)
      end
    end
    
    describe '#decrement_position' do
      it 'should decrement it\'s position by 1' do
        page = Factory.create :page
        position = page.position
        page.decrement_position
        page.position.should == (position - 1)
      end
    end
    
    describe '#preceding_sibling' do
      it 'should find the predecing sibling' do
        page1 = Factory.create :page
        page2 = Factory.create :page
        page3 = Factory.create :page
        page3.preceding_sibling.id.should == page2.id
      end
    end
    
    describe '#succeeding_sibling' do
      it 'should find the succeeding sibling' do
        page1 = Factory.create :page
        page2 = Factory.create :page
        page3 = Factory.create :page
        page2.succeeding_sibling.id.should == page3.id
      end
    end
    
    describe '#reposition' do
      it 'should reposition before a page, specified by id' do
        page1 = Factory.create :page
        page2 = Factory.create :page
        page3 = Factory.create :page
        page3.reposition page1.id
        page3.preceding_sibling.id.should == page1.id
      end
    
      it 'should reposition before all siblings, specified by nil' do
        page1 = Factory.create :page
        page2 = Factory.create :page
        page2.reposition nil
        page2.position.should == 1
      end
    end
    
    describe '#siblings' do
      pending 'describe'
    end
    
    describe '#position_to_top' do
      pending 'describe'
    end
    
    describe '#recount_siblings_position_from' do
      pending 'describe'
    end
    
    describe '#reposition' do
      pending 'describe'
    end
    
    describe '#set_position' do
      pending
    end    
  end
  
  describe 'should delegate' do
    it 'slug, title, published, published?, page_type, fulltext, keywords, page_parts and description to the translation' do
      [:slug, :title, :published, :published?, :page_type, :fulltext, :keywords, :page_parts, :description].each do |attr|
        @page.send(attr).should eq(@page.translation.send(attr))
      end
    end
    
    it 'url to the translation' do
      @page.url.should eq(@page.translation.url)
    end
    
    it 'locale to the translation' do
      @page.locale.should be(@page.translation.locale)
    end
  end
end