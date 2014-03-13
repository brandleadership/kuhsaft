require 'spec_helper'

describe Kuhsaft::Api::PagesController do
  describe '#index' do
    before do
      @pages = []
      @pages << @page1 = create(:page, published: true, title_de: 'foobar de', url_de: 'de/foobar-de', title_en: 'foobar en', url_en: 'en/foobar-en')
      @pages << @page2 = create(:page, published: true, title_de: 'barfoo de', url_de: 'de/barfoo-de', title_en: 'barfoo en', url_en: 'en/barfoo-en')
      @pages << @unpublished = create(:page, published: false, title_de: 'unpublished de', url_de: 'de/unpublished-de', title_en: 'unpublished en', url_en: 'en/unpublished-en')
    end

    it 'gets published pages' do
      I18n.with_locale :de do
        get(:index, { use_route: :kuhsaft })
        expect(JSON.parse(response.body)).to eq([@page1, @page2].as_json)
      end
    end
  end
end
