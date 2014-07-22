require 'spec_helper'

describe PagesHelper, type: :helper do
  describe '#search_page_form' do

    context 'without block' do
      it 'renders the default search form' do
        form = search_page_form
        expect(form).to have_css('form.form-inline')
        expect(form).to have_css('input[type=text]')
        expect(form).to have_css('input[type=submit]')
      end
    end

    context 'with block' do
      it 'calls the given block' do
        expect { |b| search_page_form(&b) }.to yield_with_no_args
      end
    end
  end
end
