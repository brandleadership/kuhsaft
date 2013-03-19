require 'spec_helper'

describe Kuhsaft::PublishState do
  context 'unpublished' do
    before do
      @publish_state = Kuhsaft::PublishState.new(:name => 'unpublished', :value => Kuhsaft::PublishState::UNPUBLISHED)
    end
    
    it 'should be UNPUBLISHED' do
      @publish_state.value.should be(Kuhsaft::PublishState::UNPUBLISHED)
    end
  end
  
  context 'published' do
    before do
      @publish_state = Kuhsaft::PublishState.new(:name => 'published', :value => Kuhsaft::PublishState::PUBLISHED)
    end
    
    it 'should be PUBLISHED' do
      @publish_state.value.should be(Kuhsaft::PublishState::PUBLISHED)
    end
  end
  
  context 'published_at' do
    before do
      @publish_state = Kuhsaft::PublishState.new(:name => 'published_at', :value => Kuhsaft::PublishState::PUBLISHED_AT)
    end
    
    it 'should be PUBLISHED_AT' do
      @publish_state.value.should be(Kuhsaft::PublishState::PUBLISHED_AT)
    end
  end
end