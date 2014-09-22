require 'spec_helper'

describe Kuhsaft::TwoColumnBrick, type: :model do

  let :two_column_brick do
    Kuhsaft::TwoColumnBrick.new
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(two_column_brick.user_can_add_childs?).to be_falsey
    end
  end

  describe '#user_can_delete?' do
    it 'returns true' do
      expect(two_column_brick.user_can_delete?).to be_truthy
    end
  end

  describe '#user_can_save?' do
    it 'returns true' do
      expect(two_column_brick.user_can_save?).to be_truthy
    end
  end

  describe '#renders_own_childs?' do
    it 'returns true' do
      expect(two_column_brick.renders_own_childs?).to be_truthy
    end
  end

  describe '#partitioning' do
    context 'when no partition is set' do
      it 'returns 0 (50/50)' do
        expect(two_column_brick.partitioning).to be(0)
      end
    end

    context 'when the partition is set' do
      it 'returns the value' do
        two_column_brick.partitioning = 1
        expect(two_column_brick.partitioning).to be(1)
      end
    end
  end

  describe '.partitionings' do
    it 'returns the 3 default partitions' do
      expect(Kuhsaft::TwoColumnBrick.partitionings.size).to eq(3)
    end
  end

  describe '#create' do
    it 'creates two single columns as childs' do
      two_column_brick.save
      expect(two_column_brick.bricks).to be_all { |brick| expect(brick).to be_a(Kuhsaft::ColumnBrick) }
    end
  end

  describe '#bricks' do
    it 'can have childs' do
      expect(two_column_brick).to respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'adds the row class to the default styles' do
      expect(Kuhsaft::TwoColumnBrick.new.to_style_class).to eq('kuhsaft-two-column-brick row-fluid')
    end
  end

  describe '#add_columns' do
    it 'sets the position of the first column brick to 1' do
      expect(Kuhsaft::TwoColumnBrick.new.send(:add_columns).to_a.first.position).to eq(1)
    end

    it 'sets the position of the second column brick to 2' do
      expect(Kuhsaft::TwoColumnBrick.new.send(:add_columns).to_a.second.position).to eq(2)
    end
  end
end
