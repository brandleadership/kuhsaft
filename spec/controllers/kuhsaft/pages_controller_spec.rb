require 'spec_helper'

describe Kuhsaft::PagesController do
  subject { described_class }

  describe '#show' do
    context 'without url' do
      before do
        @page = FactoryGirl.create(:page, :url_de => 'de')
      end

      context 'with matching locale' do
        it 'sets the corresponding page' do
          I18n.with_locale(:de) do
            get(:show,  { :use_route => :kuhsaft })
          end
          assigns(:page).should eq(@page)
        end
      end

      context 'without matching locale' do
        it 'raises a routing error' do
          I18n.with_locale(:en) do
            expect { get(:show,  { :use_route => :kuhsaft }) }.to raise_error(ActionController::RoutingError)
          end
        end
      end
    end
  end
end
