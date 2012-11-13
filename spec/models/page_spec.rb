require 'spec_helper'

describe Kuhsaft::Page do
  subject { described_class }

  describe '.search' do
    before do
      create :page
      create :page
      create :page
    end

    it 'should find any containing the search term' do
      Kuhsaft::Page.search('lorem').should have_at_least(0).items
    end

    it 'should find with "English Title"' do
      Kuhsaft::Page.search('English Title').should have_at_least(1).item
    end

    it 'should only find published results' do
      Kuhsaft::Page.search('English Title').should be_all { |p| p.published? == true }
    end
  end

  describe '.childs' do
    it 'has child pages' do
      page = create(:page)
      page.childs << create(:page)
      page.childs.size.should be(1)
    end
  end

  describe '.root_pages' do
    it 'has a list of the toplevel pages' do
      root_page = create(:page)
      Kuhsaft::Page.root_pages.size.should be(1)
    end
  end

  describe '.position_of' do
    it 'should find the position of a page' do
      page = create(:page)
      Kuhsaft::Page.position_of(page.id).should == page.position
    end
  end

  describe '.find_by_url' do
    it 'should find its translated content by url' do
      page = create(:page)
      Kuhsaft::Page.find_by_url(page.url).should eq(page)
    end
  end

  describe '.flat_tree' do
    it 'should create an ordered, flat list of the page tree' do
      tree = create_page_tree
      Kuhsaft::Page.flat_tree.should eq(tree)
    end
  end

  describe '#initialize' do
    context 'without values' do
      let :page do
        Kuhsaft::Page.new
      end

      before do
        page.valid?
      end

      it 'has a mandatory title' do
        page.should have(1).error_on(:title)
      end

      it 'has a mandatory slug' do
        page.should have(1).error_on(:slug)
      end
    end
  end

  describe '#published' do
    it 'returns only published pages' do
      p1, p2, p3 = 3.times.map { create(:page) }
      p2.update_attribute :published, Kuhsaft::PublishState::UNPUBLISHED
      Kuhsaft::Page.published.should be_all { |p| p.published?.should be_true }
    end
  end

  describe '#root?' do
    it 'should return true for a page without a parent' do
      create(:page).root?.should be_true
    end
  end

  describe '#without_self' do
    it 'returns pages but not itself' do
      2.times { create(:page) }
      page = Kuhsaft::Page.first
      page.without_self.should_not include(page)
    end
  end

  describe '#nesting_name' do
    before do
      @p1, @p2, @p3 = create_page_tree
    end

    context 'on the topmost level' do
      it 'should have a label representing it\'s nesting depth without a leading dash' do
        @p1.nesting_name.should eq(@p1.title)
      end
    end

    context 'on the first level' do
      it 'should have a label with one dash' do
        @p2.nesting_name.should eq("- #{@p2.title}")
      end
    end

    context 'on the second level' do
      it 'should have a label with two dashes' do
        @p3.nesting_name.should eq("-- #{@p3.title}")
      end
    end
  end

  describe '#siblings' do
    it 'knows the siblings' do
      create(:page).should respond_to(:siblings)
    end

    it 'returns a list of pages' do
      create(:page).siblings.should be_all { |p| p.should be_an_instance_of(Kuhsaft::Page) }
    end
  end

  describe '#parent' do
    it 'has a parent page' do
      page  = create(:page)
      child = create(:page)
      page.childs << child
      child.parent.should eq(page)
    end
  end

  describe '#page_part_type' do
    it 'accepts a page_part_type to determine which page_part needs to be added' do
      subject.new.should respond_to(:page_part_type)
    end
  end

  describe '#parent_pages' do
    let :page do
      p1 = create(:page)
      p2 = create(:page)
      p1.childs << p1
      p2
    end

    it 'has a list of parent pages' do
      page.parent_pages.should be_instance_of(Array)
    end

    it 'is ordered from top to bottom' do
      page.parent_pages.last.should be(page)
    end
  end

  describe '#link' do
    context 'when it has no content' do
      it 'should return the link of it\'s first child' do
        page = create :page
        child = create :page
        page.childs << child
        page.body = nil
        page.save
        page.link.should == child.link
      end
    end
  end


  describe '#increment_position' do
    it 'increments the position by 1' do
      page = create :page
      position = page.position
      page.increment_position
      page.position.should == (position + 1)
    end
  end

  describe '#decrement_position' do
    it 'decrements the position by 1' do
      page = create :page
      position = page.position
      page.decrement_position
      page.position.should == (position - 1)
    end
  end

  describe '#preceding_sibling' do
    it 'finds the predecing sibling' do
      page1 = create :page
      page2 = create :page
      page3 = create :page
      page3.preceding_sibling.id.should == page2.id
    end
  end

  describe '#succeeding_sibling' do
    it 'finds the succeeding sibling' do
      page1 = create :page
      page2 = create :page
      page3 = create :page
      page2.succeeding_sibling.id.should == page3.id
    end
  end

  describe '#reposition' do
    it 'repositions before a page, specified by id' do
      page1 = create :page
      page2 = create :page
      page3 = create :page
      page3.reposition page1.id
      page3.preceding_sibling.id.should == page1.id
    end

    it 'repositions before all siblings, specified by nil' do
      page1 = create :page
      page2 = create :page
      page2.reposition nil
      page2.position.should == 1
    end
  end

  describe '#slug' do
    let :page do
      build(:page)
    end

    it 'has a slug by default' do
      page.save
      page.slug.should eq(page.title.parameterize)
    end

    context 'when it is empty' do
      it 'generates the slug' do
        page.should_receive(:create_slug)
        page.save
      end
    end

    context 'when it is not empty' do
      it 'takes the slug provided by the user' do
        page.slug = 'my-slug'
        page.save
        page.slug.should == 'my-slug'
      end
    end
  end

  describe '#url' do
    context 'when it is a normal page' do
      it 'returns the concatenated slug of the whole child/parent tree' do
        page = create(:page, :slug => 'parent-slug', :page_type => '')
        child = create(:page, :slug => 'child-slug', :page_type => '')
        page.childs << child
        child.url.should == 'en/parent-slug/child-slug'
      end
    end

    context 'when it is a navigation? page' do
      it 'returns without the parent page slug' do
        page = create(:page, :slug => 'parent-slug', :page_type => Kuhsaft::PageType::NAVIGATION)
        child = create(:page, :slug => 'child-slug', :page_type => '')
        page.childs << child
        child.url.should == 'en/child-slug'
      end
    end

    context 'when it is a redirect? page' do
      it 'returns the plain url' do
        page = create(:page, :page_type => Kuhsaft::PageType::REDIRECT, :url => '/en/news')
        page.link.should eq('/en/news')
      end
    end
  end

  describe '#navigation?' do
    context 'when the page_type is navigation' do
      it 'returns true if the page_type is PageType::NAVIGATION' do
        Kuhsaft::Page.new(:page_type => Kuhsaft::PageType::NAVIGATION).navigation?.should be_true
      end
    end

    context 'when the page_type is anything else' do
      it 'returns false' do
        Kuhsaft::Page.new(:page_type => Kuhsaft::PageType::REDIRECT).navigation?.should be_false
      end
    end
  end

  describe '#redirect?' do
    context 'when the page_type is a redirect' do
      it 'returns true' do
        Kuhsaft::Page.new(:page_type => Kuhsaft::PageType::REDIRECT).redirect?.should be_true
      end
    end

    context 'when the page type is anything else' do
      it 'returns false' do
        Kuhsaft::Page.new(:page_type => Kuhsaft::PageType::NAVIGATION).redirect?.should be_false
      end
    end
  end

  describe '#fulltext' do
    let :page do
      p = create(:page, :keywords => 'key words', :description => 'descrip tion', :title => 'my title')
      p.page_parts << Kuhsaft::PagePart::Markdown.new(:text => 'oh la la')
      p.save
      p
    end

    context 'when saved' do
      it 'it collects and assigns the fulltext' do
        page.should_receive(:collect_fulltext)
        page.save
      end

      it 'contains the title' do
        page.fulltext.should include('my title')
      end

      it 'contains the keywords' do
        page.fulltext.should include('key words')
      end

      it 'contains the description' do
        page.fulltext.should include('descrip tion')
      end

      it 'contains the page part content' do
        page.fulltext.should include('oh la la')
      end

      it 'converts all data to strings' do
        expect { page.collect_fulltext }.to_not raise_error
      end
    end
  end
end
