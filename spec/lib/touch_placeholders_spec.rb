require 'spec_helper'
require_relative '../../lib/kuhsaft/touch_placeholders'

describe Kuhsaft::TouchPlaceholders do

  before :all do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :dummy_models do |t|
      t.timestamps
    end

    class DummyModel < ActiveRecord::Base
      include Kuhsaft::TouchPlaceholders
    end

    @page = FactoryGirl.create(:page)
    @placeholder = FactoryGirl.create(:placeholder_brick, brick_list: @page, template_name: 'foo')
  end

  after :all do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.drop_table :dummy_models

    @page.destroy
    @placeholder.destroy
  end

  describe 'placeholder_templates class method' do
    it 'returns the attribute names defined with class macro' do
      DummyModel.class_eval { placeholder_templates 'key_benefit_slider', 'key_benefit_grid' }
      expect(DummyModel.placeholder_templates).to eq %w[key_benefit_slider key_benefit_grid]
    end
  end

  describe 'after_save_callback' do
    it 'looks for the bricks with affected templates and touches them' do
      DummyModel.class_eval { placeholder_templates 'foo' }
      expect_any_instance_of(Kuhsaft::PlaceholderBrick).to receive(:touch)
      DummyModel.create
    end
  end
end
