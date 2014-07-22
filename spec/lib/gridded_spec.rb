require 'spec_helper'

describe Kuhsaft::Gridded do

  context 'included gridded module' do
    class GridClass
      include Kuhsaft::Gridded
    end

    it 'returns an array for the gridded class' do
      expect(GridClass.available_grid_sizes).to be_kind_of(Array)
    end

    it 'returns false on gridded? if no col count is set' do
      expect_any_instance_of(GridClass).to receive(:col_count).at_least(:once).and_return(0)
      expect(GridClass.new.gridded?).to be_falsey
    end

    it 'returns true on gridded? if a col count is set' do
      expect_any_instance_of(GridClass).to receive(:col_count).at_least(:once).and_return(10)
      expect(GridClass.new.gridded?).to be_truthy
    end
  end
end
