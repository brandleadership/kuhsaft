require 'spec_helper'

describe Kuhsaft::Cms::PagesController do
  subject { described_class }

  describe 'mirroring' do
    around(:each) do |example|
      I18n.with_locale :de do
        example.run
      end
    end

    before do
      @page  = FactoryGirl.create(:page, url_de: 'de')
      @brick = FactoryGirl.create(:text_brick,
                                  brick_list_id: @page.id,
                                  brick_list_type: 'Kuhsaft::Page',
                                  text: 'DEUTSCH')
    end

    context 'with no bricks on target locale' do
      it 'clones the existing bricks' do
        xhr :get, :mirror, use_route: :kuhsaft, target_locale: :en, page_id: @page.id
        expect(@page.bricks.unscoped.count).to eq(2)
      end
    end

    context 'with bricks on target locale' do
      before do
        @brick_en = FactoryGirl.create(:text_brick,
                                       brick_list_id: @page.id,
                                       brick_list_type: 'Kuhsaft::Page',
                                       locale: :en,
                                       text: 'ENGLISH')
      end

      it 'does not clone anything without the required parameter' do
        xhr :get, :mirror, use_route: :kuhsaft, target_locale: :en, page_id: @page.id
        expect(@page.bricks.unscoped.where(locale: :en).first.text).to eq('ENGLISH')
      end

      it 'clones the bricks when required parameter is set' do
        xhr :get, :mirror, use_route: :kuhsaft, target_locale: :en, page_id: @page.id, rutheless: 'true'
        expect(@page.bricks.unscoped.where(locale: :en).first.text).to eq('DEUTSCH')
      end
    end
  end
end
