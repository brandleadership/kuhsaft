require 'spec_helper'
require 'fileutils'

describe Kuhsaft::PlaceholderBrick do

  let :placeholder_brick do
    Kuhsaft::PlaceholderBrick.new
  end

  before do
    FileUtils.mkdir_p("#{Rails.root}/app/views/kuhsaft/placeholder_bricks/partials")
    FileUtils.touch("#{Rails.root}/app/views/kuhsaft/placeholder_bricks/partials/_valid_partial.html.haml")
    FileUtils.touch("#{Rails.root}/app/views/kuhsaft/placeholder_bricks/partials/not_a_partial.html.haml")
    FileUtils.touch("#{Rails.root}/app/views/kuhsaft/placeholder_bricks/partials/_not_a_haml_file.txt")
  end

  after do
    FileUtils.rm_rf(Dir.glob("#{Rails.root}/app/views/kuhsaft"))
  end

  describe 'available partials' do
    it 'returns haml files' do
      Kuhsaft::PlaceholderBrick.available_partials.flatten.should include('valid_partial')
    end

    it 'returns only partials' do
      Kuhsaft::PlaceholderBrick.available_partials.flatten.should_not include('not_a_partial')
    end

    it 'does not return other files' do
      Kuhsaft::PlaceholderBrick.available_partials.flatten.should_not include('not_a_haml_file')
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      placeholder_brick.should_not respond_to(:bricks)
    end
  end
end
