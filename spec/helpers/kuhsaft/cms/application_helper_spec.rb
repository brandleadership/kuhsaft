require 'spec_helper'

describe Kuhsaft::Cms::ApplicationHelper do
  describe '#render_language_switch?' do
    context 'when there is one language' do
      before do
        I18n.stub(:available_locales).and_return([:de])
      end

      it 'returns false' do
        helper.render_language_switch?.should be_false
      end
    end

    context 'when there are multiple languages' do
      before do
        I18n.stub(:available_locales).and_return([:de, :en])
      end

      it 'returns true' do
        helper.render_language_switch?.should be_true
      end
    end
  end
end
