require 'spec_helper'

describe 'pages#index' do
  context 'with search parameter' do
    let! :page1 do
      p = create :page,
        :page_type => Kuhsaft::PageType::CONTENT,
        :published => true,
        :navigation_name => 'Chromodorididae Ardeadoris',
        :title => 'Animalia - Ardeadoris'
      p.bricks << Kuhsaft::TextBrick.new(:locale => I18n.locale, :text => "#{'foo bar' * 300} Chromodorididae #{'foo bar' * 300}")
      p.save!
      p
    end

    let! :page2 do
      create :page,
        :page_type => Kuhsaft::PageType::CONTENT,
        :published => true,
        :navigation_name => 'Chromodorididae Berlanguella',
        :title => 'Animalia - Berlanguella'
    end

    let! :page3 do
      create :page,
        :page_type => Kuhsaft::PageType::CONTENT,
        :published => true,
        :navigation_name => 'Gastropoda'
    end

    context 'with fulltext' do
      before do
        visit kuhsaft.pages_path(:locale => :en, :search => 'Chromodorididae')
      end

      it 'highlights search term in preview' do
        within("ul.search-results strong.highlight") do
          page.should have_content('Chromodorididae')
        end
      end

      it 'truncates the text' do
        find('.summary .fulltext').text.length.should < 200
      end
    end

    context 'with multiple matches' do
      before do
        visit kuhsaft.pages_path(:locale => :en, :search => 'Animalia')
      end

      it 'renders match count' do
        page.should have_content("2 results")
      end

      it 'renders the search results list' do
        within("ul.search-results.success") do
          page.should have_content('Chromodorididae Ardeadoris')
          page.should have_content('Chromodorididae Berlanguella')
          page.should_not have_content('Gastropoda')
        end
      end

      it 'renders links to the pages' do
        within("ul.search-results.success") do
          page.should have_link('Chromodorididae Ardeadoris', href: page1.link)
          page.should have_link('Chromodorididae Berlanguella', href: page2.link)
        end
      end
    end

    context 'without matches' do
      before do
        visit kuhsaft.pages_path(:locale => :en, :search => 'foobar')
      end

      it 'renders match count' do
        page.should have_content("No results")
      end
    end
  end
end
