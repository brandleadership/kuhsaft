require 'spec_helper'

describe Kuhsaft::Api::PagesController, type: :controller do
  describe '#index' do
    before do
      @pages = []
      @pages << @page1 = create(:page, published: true, title_de: 'foobar de',
                                       url_de: 'de/foobar-de', title_en: 'foobar en', url_en: 'en/foobar-en')
      @pages << @page2 = create(:page, published: true, title_de: 'barfoo de',
                                       url_de: 'de/barfoo-de', title_en: 'barfoo en', url_en: 'en/barfoo-en')
      @pages << @unpublished = create(:page, published: false, title_de: 'unpublished de',
                                             url_de: 'de/unpublished-de', title_en: 'unpublished en',
                                             url_en: 'en/unpublished-en')
    end

    it 'gets only published pages' do
      I18n.with_locale :de do
        get :index, use_route: :kuhsaft
        expect(JSON.parse(response.body)).to eq([@page1, @page2].as_json)
      end
    end

    it 'gets specific translated pages for each locale' do
      I18n.with_locale :de do
        @pages << @only_german = create(:page, published: true, title: 'foobar de', url: 'de/foobar-de')
        get :index, use_route: :kuhsaft
        expect(JSON.parse(response.body)).to eq([@page1, @page2, @only_german].as_json)
      end

      I18n.with_locale :en do
        get :index, use_route: :kuhsaft
        expect(JSON.parse(response.body)).to eq([@page1, @page2].as_json)
      end
    end
  end

  describe 'expected json format of a page' do
    before do
      @pages = []
      @pages << @page1 = create(:page, published: true, title_de: 'foobar de',
                                       url_de: 'de/foobar-de', title_en: 'foobar en', url_en: 'en/foobar-en')
      @pages << @page2 = create(:page, published: true, title_de: 'barfoo de',
                                       url_de: 'de/barfoo-de', title_en: 'barfoo en', url_en: 'en/barfoo-en')

      I18n.with_locale :de do
        get :index, use_route: :kuhsaft
        @json = JSON.parse(response.body)
        @page_hash = @json.first
      end
    end

    it 'contains the title' do
      I18n.with_locale :de do
        expect(@page_hash['title']).to eq(@page1.title)
      end
    end

    it 'contains the url with page ID' do
      I18n.with_locale :de do
        expect(@page_hash['url']).to eq('/pages/' + @page1.id.to_s)
      end
    end

    it 'does not contain the slug' do
      I18n.with_locale :de do
        expect(@page_hash['slug']).to eq(nil)
      end
    end
  end
end
