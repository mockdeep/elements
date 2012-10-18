require 'spec_helper'

describe Element do
  before :each do
    @user = FactoryGirl.create(:user)
    @parent_element = FactoryGirl.create(:element, :user => @user)
    @child_element = FactoryGirl.create(:element, :user => @user)
    @parent_element.children << @child_element
  end

  it "has a default scope of unfinished" do
    @child_element.update_attributes(:done => true)
    Element.all.should eq [ @parent_element ]
  end

  describe '#update_attributes' do
    it 'does not mass assign id' do
      new_id = UUIDTools::UUID.random_create.to_s
      @parent_element.update_attributes(:id => new_id)
      @parent_element.id.should_not == new_id
    end

    it 'does mass assign title' do
      @parent_element.update_attributes(:title => 'wah!')
      @parent_element.title.should == 'wah!'
    end

    it 'does mass assign starts_at' do
      new_time = Time.zone.parse('2012-05-10')
      @parent_element.update_attributes(:starts_at => new_time)
      @parent_element.starts_at.should == new_time
    end

    it 'does mass assign due_at' do
      new_time = Time.zone.parse('2012-05-10')
      @parent_element.update_attributes(:due_at => new_time)
      @parent_element.due_at.should == new_time
    end

    it 'does mass assign value' do
      @parent_element.update_attribute(:value, 5)
      @parent_element.update_attributes(:value => 9)
      @parent_element.value.should == 9
    end

    it 'does mass assign urgency' do
      @parent_element.update_attribute(:urgency, 5)
      @parent_element.update_attributes(:urgency => 9)
      @parent_element.urgency.should == 9
    end
  end

  describe '.roots' do
    it 'returns the top level elements' do
      Element.roots.should == [ @parent_element ]
    end
  end

  describe '.leafs' do
    it 'returns leaf elements' do
      Element.leafs.should == [ @child_element ]
    end
  end

  describe '.ranked' do
    context 'without paremeters' do
      it 'returns elements by rank in descending order' do
        @parent_element.update_attributes(:value => 9)
        @child_element.update_attributes(:value => 8)
        Element.ranked.should == [ @parent_element, @child_element ]
      end
    end

    context 'given :asc paremeter' do
      it 'returns elements by rank in ascending order' do
        @parent_element.update_attributes(:value => 9)
        @child_element.update_attributes(:value => 8)
        Element.ranked(:asc).should == [ @child_element, @parent_element ]
      end
    end
  end

  describe '#update_rank' do
    context 'when element is saved' do
      it 'recalculates the rank for the element' do
        @parent_element.update_attributes(:value => 9)
        @parent_element.rank.should == 900
      end
    end
  end

  describe '#to_s' do
    it 'returns the title of the task' do
      @parent_element.to_s.should == @parent_element.title
    end
  end

  describe '#destroy' do
    context 'given an element with children' do
      it 'destroys child elements' do
        @parent_element.destroy
        Element.find_by_id(@child_element.id).should be_nil
      end
    end

    context 'given an element with a parent' do
      it 'does not destroy parent element' do
        @child_element.destroy
        Element.find_by_id(@parent_element.id).should_not be_nil
      end
    end
  end

  describe '#valid?' do
    context 'without a user' do
      before :each do
        @element = Element.new(:title => 'do something')
      end

      it 'returns false' do
        @element.should_not be_valid
      end

      it 'has an error on user' do
        @element.valid?
        @element.errors[:user].should == [ "can't be blank" ]
      end
    end
  end

  describe '#roots' do
    it 'returns elements only for that user' do
      user2 = FactoryGirl.create(:user)
      element1 = FactoryGirl.create(:element, :user => user2)
      options = { :user => user2, :parent => element1 }
      element2 = FactoryGirl.create(:element, options)
      user2.elements.roots.should == [ element1 ]
    end
  end

  describe '#leafs' do
    it 'returns elements only for that user' do
      user2 = FactoryGirl.create(:user)
      element1 = FactoryGirl.create(:element, :user => user2)
      options = { :user => user2, :parent => element1 }
      element2 = FactoryGirl.create(:element, options)
      user2.elements.leafs.should == [ element2 ]
    end

    it 'returns all elements if there are no parents' do
      user = FactoryGirl.create(:user)
      element = FactoryGirl.create(:element, :user => user)
      user.elements.leafs.should == [ element ]
    end
  end

  describe '#done' do
    context 'when set to true' do
      it 'sets done_at' do
        @parent_element.done = true
        @parent_element.done_at.should_not be_nil
      end

      it 'marks child elements as done' do
        @parent_element.done = true
        @child_element.done_at.should_not be_nil
      end

      it 'does not mark parent elements as done' do
        @child_element.done = true
        @parent_element.reload.done_at.should be_nil
      end
    end

    context 'when set to false' do
      it 'sets done_at back to nil' do
        @parent_element.done = true
        @parent_element.done = false
        @parent_element.done_at.should be_nil
      end
    end
  end
end
