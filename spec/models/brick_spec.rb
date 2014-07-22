require 'spec_helper'

describe Kuhsaft::Brick, type: :model do
  let :brick do
    Kuhsaft::Brick.new
  end

  describe '#valid?' do
    it 'sets a default position' do
      expect(brick).to receive(:set_position)
      brick.valid?
    end
  end

  describe '#set_position' do
    context 'witout a position' do
      it 'sets a default' do
        brick.set_position
        expect(brick.position).to be(1)
      end
    end

    context 'with a position' do
      it 'does not change' do
        brick.position = 3
        expect { brick.set_position }.to_not change(brick, :position)
      end
    end
  end

  describe '#brick_list_type' do
    it 'returns Kuhsaft::Brick' do
      expect(brick.brick_list_type).to eq('Kuhsaft::Brick')
    end
  end

  describe '#parents' do
    it 'returns the chain of parents' do
      item1, item2, item3 = double, double, Kuhsaft::Brick.new
      allow(item2).to receive(:brick_list).and_return(item1)
      allow(item3).to receive(:brick_list).and_return(item2)
      expect(item3.parents).to eq([item1, item2])
    end
  end

  describe '#to_edit_partial_path' do
    it 'returns the path to the form partial' do
      expect(Kuhsaft::TextBrick.new.to_edit_partial_path).to eq('kuhsaft/text_bricks/text_brick/edit')
    end
  end

  describe '#has_siblings?' do
    it 'returns false if the brick has no siblings' do
      brick = Kuhsaft::Brick.new
      expect(brick.has_siblings?).to be_falsey
    end

    it 'returns true if the brick has siblings' do
      item1, item2, item3 = double, double, Kuhsaft::Brick.new
      allow(item1).to receive(:bricks).and_return([item2, item3])
      allow(item2).to receive(:brick_list).and_return(item1)
      allow(item3).to receive(:brick_list).and_return(item1)
      expect(item3.has_siblings?).to be_truthy
    end
  end

  describe '#to_edit_childs_partial_path' do
    it 'returns the path to the form partial' do
      expect(Kuhsaft::TextBrick.new.to_edit_childs_partial_path).to eq('kuhsaft/text_bricks/text_brick/childs')
    end
  end

  describe '#bricks' do
    it 'can not have childs by default' do
      expect(brick).not_to respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'returns a css classname' do
      expect(Kuhsaft::TextBrick.new.to_style_class).to eq('kuhsaft-text-brick')
    end
  end

  describe '#to_style_id' do
    it 'returns a unique DOM id' do
      brick = Kuhsaft::TextBrick.new
      allow(brick).to receive(:id).and_return(104)
      expect(brick.to_style_id).to eq('kuhsaft-text-brick-104')
    end
  end

  describe '#backend_label' do
    it 'returns the name of the brick' do
      brick =  Kuhsaft::TextBrick.new
      expect(brick.backend_label).to eq('Text')
    end

    context 'with the parenthesis option given' do
      brick = Kuhsaft::TextBrick.new
      brick.backend_label(parenthesis: true).should == '(Text)'
    end
  end

  describe '#uploader?' do
    it 'returns false' do
      expect(brick.uploader?).to be_falsey
    end
  end

  describe '#after_save' do
    describe 'update_fulltext' do
      let! :brick do
        Kuhsaft::Brick.new.tap do |b|
          b.type = Kuhsaft::BrickType.new
        end
      end

      let! :brick_list do
        p = create(:page)
        p.bricks << brick
        p.save
        p
      end

      it 'updates fulltext on bricklist after saving a single brick' do
        expect(brick.brick_list).to receive(:update_fulltext)
        expect(brick.brick_list).to receive(:save!)
        brick.text = 'foobar'
        brick.save
      end
    end
  end
end
