require 'spec_helper'
require 'fileutils'

describe Kuhsaft::PlaceholderBrick, type: :model do

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
      expect(Kuhsaft::PlaceholderBrick.available_partials.flatten).to include('valid_partial')
    end

    it 'returns only partials' do
      expect(Kuhsaft::PlaceholderBrick.available_partials.flatten).not_to include('not_a_partial')
    end

    it 'does not return other files' do
      expect(Kuhsaft::PlaceholderBrick.available_partials.flatten).not_to include('not_a_haml_file')
    end
  end

  describe '#bricks' do
    it 'can not have childs' do
      expect(placeholder_brick).not_to respond_to(:bricks)
    end
  end

  describe '#user_can_add_childs?' do
    it 'returns false' do
      expect(placeholder_brick.user_can_add_childs?).to be_falsey
    end
  end
end
