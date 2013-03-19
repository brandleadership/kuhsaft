require 'spec_helper'

describe Kuhsaft::LocalizedPage do
  before :each do
    @page = Factory::create :page
    @localized_page = @page.translation
  end
  
  describe 'associations' do
    describe '#page_parts' do
      it 'should have many page parts' do
        @localized_page.should respond_to(:page_parts)
      end
    end
    
    describe '#page' do
      it 'should belongs to a page' do
        @localized_page.should respond_to(:page)
      end
    end
  end
  
  describe 'instance methods' do
    describe '#locale' do
      it 'should have a locale' do
        @localized_page.should respond_to(:locale)
      end
    
      it 'should be a Symbol' do
        @localized_page.locale.should be_an_instance_of(Symbol)
      end
    end
  
    describe '#published?' do
      it 'should know if it\'s published' do
        @localized_page.should respond_to(:published?)
      end
    
      context 'when the published state is UNPUBLISHED' do
        it 'should not be published' do
          @localized_page.update_attribute :published, Kuhsaft::PublishState::UNPUBLISHED
          @localized_page.published?.should be_false
        end
      
        context 'when a published_at date is set' do
          it 'should not be published' do
            @localized_page.update_attribute :published, Kuhsaft::PublishState::UNPUBLISHED
            @localized_page.update_attribute :published_at, Time.now - 2.days
            @localized_page.published?.should be_false
          end
        end
      end
    
      context 'when the published state is PUBLISHED' do 
        it 'should be published' do
          @localized_page.update_attribute :published, Kuhsaft::PublishState::PUBLISHED
          @localized_page.published?.should be_true
        end
      
        context 'when the published_at date is set' do
          it 'should be published' do
            @localized_page.update_attribute :published, Kuhsaft::PublishState::PUBLISHED
            @localized_page.update_attribute :published_at, Time.now + 2.days
            @localized_page.published?.should be_true
          end
        end
      end

      context 'when the published state is PUBLISHED_AT' do
        it 'should be published if the date is in the past' do
          @localized_page.update_attribute :published, Kuhsaft::PublishState::PUBLISHED_AT
          @localized_page.update_attribute :published_at, Time.now - 2.days
          @localized_page.published?.should be_true
        end

        it 'should not be published if the date is in the future' do
          @localized_page.update_attribute :published, Kuhsaft::PublishState::PUBLISHED_AT
          @localized_page.update_attribute :published_at, Time.now + 2.days
          @localized_page.published?.should be_false
        end
      end
    end

    describe '#slug' do
      it 'should have a slug' do
        @localized_page.should respond_to(:slug)
      end

      context 'when it is empty' do
        it 'should be generated' do
          @localized_page.should_receive(:create_slug)
          @localized_page.save
        end
      
        it 'should use the title to generate the slug' do
          @localized_page.slug.should eq(@localized_page.title.parameterize)
        end
      end
    
      context 'when it is not empty' do
        it 'should take the slug provided by the user' do
          Factory.create(:localized_page, :slug => 'my-slug').slug.should == 'my-slug'
        end
      end
    end
    
    describe '#url' do
      it 'should have an url' do
        @localized_page.should respond_to(:url)
      end

      context 'when saving the localized_page' do
        context 'when it is a normal page' do
          it 'should include the parents slug in its url' do
            page = Kuhsaft::Page.new
            page.localized_pages << Kuhsaft::LocalizedPage.new(:title => 'hi', :slug => 'parent-slug', :page_type => '', :locale => :en )
            
            child = Kuhsaft::Page.new
            child.localized_pages << Kuhsaft::LocalizedPage.new(:title => 'hi', :slug => 'child-slug', :page_type => '', :locale => :en)
            
            page.childs << child
            page.save
            
            child.url.should == 'en/parent-slug/child-slug'
          end
        end

        context 'when it is a navigation?' do
          it 'the slug should be left out in the url' do
            page = Kuhsaft::Page.new
            page.localized_pages << Kuhsaft::LocalizedPage.new(:title => 'hi', :slug => 'parent-slug', :page_type => Kuhsaft::PageType::NAVIGATION, :locale => :en )
            
            child = Kuhsaft::Page.new
            child.localized_pages << Kuhsaft::LocalizedPage.new(:title => 'hi', :slug => 'child-slug', :page_type => '', :locale => :en)
            
            page.childs << child
            page.save
            
            child.url.should == 'en/child-slug'
          end
        end

        context 'when it\'s a redirect?' do
          it 'should not touch the url' do
            page = Factory.create :page
            page.translation.page_type = Kuhsaft::PageType::REDIRECT
            page.translation.url = '/en/news'
            page.save
            page.link.should eq('/en/news')  
          end
        end
      end
    end
  
    describe '#page_type' do
      it 'should have a page_type' do
        @localized_page.should respond_to(:page_type)
      end
    end
  
    describe '#navigation?' do
      it 'should be true if the page_type is PageType::NAVIGATION' do
        @page.translation.page_type = Kuhsaft::PageType::NAVIGATION
        @page.navigation?.should be_true
      end
    end

    describe '#redirect?' do
      it 'should be true if the page_type is PageType::REDIRECT' do
        @page.translation.page_type = Kuhsaft::PageType::REDIRECT
        @page.redirect?.should be_true
      end
    end
    
    describe '#fulltext' do
      before do
        @page =  Factory.create :page
        @page.translation.keywords = 'key words'
        @page.translation.description = 'descrip tion'
        @page.translation.title = 'my title'
        @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la1')
        @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la2')
        @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la3')
        @page.translation.page_parts << Kuhsaft::PagePart::Markdown.new(:text => nil)
        @page.save
      end
    
      it 'should have a fulltext' do
        @localized_page.should respond_to(:fulltext)
      end
    
      context 'when saved' do
        it 'should collect and assign the fulltext' do
          @page.translation.should_receive(:collect_fulltext)
          @page.save
        end
      
        it 'should contain the title' do
          @page.fulltext.should include('my title')
        end
    
        it 'should contain the keywords' do
          @page.fulltext.should include('key words')
        end
    
        it 'should contain the description' do
          @page.fulltext.should include('descrip tion')
        end
    
        it 'should contain the page part content' do
          @page.fulltext.should include('oh la la')
        end
    
        it 'should convert all data to strings' do
          expect { @page.translation.collect_fulltext }.to_not raise_error
        end
      end
    end
  end
  
  describe 'validations' do
    before do
      @localized_page = Factory.create :localized_page
      @localized_page.title = nil
      @localized_page.slug = nil
    end
    
    it 'should have a title' do
      @localized_page.should have(1).error_on(:title)
    end
    
    it 'should have a slug' do
      @localized_page.should have(1).error_on(:slug)
    end
    
    after do
      @localized_page.destroy
    end
  end
  
  describe 'class methods' do
    describe 'search' do
      before do
        Factory.create :page
        Factory.create :page
        Factory.create :page
      end

      it 'should find any containing the search term' do
        Kuhsaft::LocalizedPage.search('hi').should have_at_least(0).items
      end

      it 'should find with "English Title"' do
        Kuhsaft::LocalizedPage.search('English Title').should have_at_least(1).item
      end

      it 'should only find results with the current locale' do
        Kuhsaft::LocalizedPage.search('English Title').should be_all { |p| p.locale == Kuhsaft::Page.current_translation_locale }
      end

      it 'should only find published results' do
        Kuhsaft::LocalizedPage.search('English Title').should be_all { |p| p.published? == true }
      end
    end
  end
end