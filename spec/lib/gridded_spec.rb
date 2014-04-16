require 'spec_helper'

describe Kuhsaft::Gridded do

  context 'included gridded module' do
    class GridClass
      include Kuhsaft::Gridded
    end

    it 'returns an array for the gridded class' do
      GridClass.available_grid_sizes.should be_kind_of(Array)
    end

    it 'returns false on gridded? if no col count is set' do
      GridClass.any_instance.stub(:col_count).and_return(0)
      expect(GridClass.new.gridded?).to be_false
    end

    it 'returns true on gridded? if a col count is set' do
      GridClass.any_instance.stub(:col_count).and_return(10)
      expect(GridClass.new.gridded?).to be_true
    end
  end
end
