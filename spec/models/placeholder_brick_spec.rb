require 'spec_helper'
require 'fileutils'

describe Kuhsaft::PlaceholderBrick do

  let :placeholder_brick do
    Kuhsaft::PlaceholderBrick.new
  end

  before do
    FileUtils.touch("#{Rails.root}/app/views/user_templates/_valid_partial.html.haml")
    FileUtils.touch("#{Rails.root}/app/views/user_templates/not_a_partial.html.haml")
    FileUtils.touch("#{Rails.root}/app/views/user_templates/_not_a_haml_file.txt")
  end

  after do
    FileUtils.rm(Dir.glob("#{Rails.root}/app/views/user_templates/*"))
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
