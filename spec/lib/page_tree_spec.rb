require 'spec_helper'
require_relative '../../lib/kuhsaft/page_tree'
require_relative '../../app/models/kuhsaft/page'


module Kuhsaft
  describe PageTree do
    let(:page_tree) { {"0"=>{"id"=>"3", "children"=>{"0"=>{"id"=>"5"}}},
                 "1"=>{"id"=>"1", "children"=>{"0"=>{"id"=>"6"}}},
                 "2"=>{"id"=>"2"}}}

    describe 'update' do
      it 'sets the correct position of the root nodes' do
        pending "spec with newest rspec!"
        canary = double
        expect(Page).to receive(:find).with(1)
        expect(Page).to receive(:find).with(2)
        expect(Page).to receive(:find).with(3).and_return(canary)
        expect(canary).to receive(:update_attributes).with(parent_id: nil, position: 2)
        PageTree.update(page_tree)
      end
    end
  end
end
