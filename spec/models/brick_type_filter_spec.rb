require 'spec_helper'

describe Kuhsaft::BrickTypeFilter do
  let :brick_list do
    Kuhsaft::Page.new
  end

  let :brick_type_filter do
    Kuhsaft::BrickTypeFilter.new(brick_list)
  end

  describe '#empty?' do
    context 'when the user cant add childs' do
      before do
        brick_list.stub(:user_can_add_childs?).and_return(false)
      end

      it 'returns true' do
        brick_type_filter.empty?.should be_true
      end
    end

    context 'when there are no bricks to be added' do
      before do
        brick_type_filter.stub(:allowed).and_return([])
      end

      it 'returns true' do
        brick_type_filter.empty?.should be_true
      end
    end
  end

  describe '#allowed' do
    context 'when no brick types are registered' do
      it 'returns an empty array' do
        Kuhsaft::BrickType.stub_chain(:count, :zero?).and_return(true)
        brick_type_filter.allowed.should be_empty
      end
    end

    context 'when brick types are registered' do
      before do
        Kuhsaft::BrickType.stub_chain(:count, :zero?).and_return(false)
      end

      context 'when there are no constraints' do
        it 'returns all brick types' do
          brick_list.stub(:allowed_brick_types).and_return([])
          Kuhsaft::BrickType.should_receive(:all)
          brick_type_filter.allowed
        end
      end

      context 'when there are constraints' do
        it 'constrains the types' do
          brick_list.stub(:allowed_brick_types).and_return(['Kuhsaft::TextBrick'])
          Kuhsaft::BrickType.should_receive(:constrained).with(['Kuhsaft::TextBrick'])
          brick_type_filter.allowed
        end
      end
    end
  end
end
