require 'spec_helper'

describe Kuhsaft::Brick do
  let :brick do
    Kuhsaft::Brick.new
  end

  describe '#valid?' do
    it 'sets a default locale' do
      brick.should_receive(:set_locale)
      brick.valid?
    end

    it 'sets a default position' do
      brick.should_receive(:set_position)
      brick.valid?
    end
  end

  describe '#set_position' do
    context 'witout a position' do
      it 'sets a default' do
        brick.set_position
        brick.position.should be(1)
      end
    end

    context 'with a position' do
      it 'does not change' do
        brick.position = 3
        expect { brick.set_position }.to_not change(brick, :position)
      end
    end
  end

  describe '#set_locale' do
    context 'witout a locale' do
      it 'sets a default' do
        brick.set_locale
        brick.locale.should == I18n.locale
      end
    end

    context 'with a locale' do
      it 'does not change' do
        brick.locale = 'de'
        expect { brick.set_locale }.to_not change(brick, :locale)
      end
    end
  end

  describe '#brick_list_type' do
    it 'returns Kuhsaft::Brick' do
      brick.brick_list_type.should == 'Kuhsaft::Brick'
    end
  end

  describe '#fulltext' do
    it 'must be overriden' do
      expect { Kuhsaft::Brick.new }.to raise_error
    end
  end

  describe '#render_as_horizontal_form?' do
    it 'returns true by default' do
      Kuhsaft::Brick.new.render_as_horizontal_form?.should be_true
    end
  end

  describe '#parents' do
    it 'returns the chain of parents' do
      item1, item2, item3 = mock, mock, Kuhsaft::Brick.new
      item2.stub(:brick_list).and_return(item1)
      item3.stub(:brick_list).and_return(item2)
      item3.parents.should == [item1, item2]
    end
  end

  describe '#to_edit_partial_path' do
    it 'returns the path to the form partial' do
      Kuhsaft::TextBrick.new.to_edit_partial_path.should == 'kuhsaft/text_bricks/text_brick/edit'
    end
  end

  describe '#to_edit_childs_partial_path' do
    it 'returns the path to the form partial' do
      Kuhsaft::TextBrick.new.to_edit_childs_partial_path.should == 'kuhsaft/text_bricks/text_brick/childs'
    end
  end

  describe '#bricks' do
    it 'can not have childs by default' do
      brick.should_not respond_to(:bricks)
    end
  end

  describe '#to_style_class' do
    it 'returns a css classname' do
      Kuhsaft::TextBrick.new.to_style_class.should == 'kuhsaft-text-brick'
    end
  end

  describe '#to_style_id' do
    it 'returns a unique DOM id' do
      brick = Kuhsaft::TextBrick.new
      brick.stub(:id).and_return(104)
      brick.to_style_id.should == 'kuhsaft-text-brick-104'
    end
  end
end
