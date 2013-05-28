require 'spec_helper'

describe 'pages#index' do
  context 'with search parameter' do
    let! :page1 do
      create :page, :title => 'Chromodorididae Ardeadoris'
    end

    let! :page2 do
      create :page, :title => 'Chromodorididae Berlanguella'
    end

    let! :page3 do
      create :page, :title => 'Gastropoda'
    end

    context 'with multiple matches' do
      before do
        visit kuhsaft.pages_path(:locale => :en, :search => 'Chromodorididae')
      end

      it 'renders match count' do
        page.should have_content("2 Resultate")
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
        page.should have_content("Keine Resultate")
      end
    end
  end
end
