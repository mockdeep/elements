require 'spec_helper'

describe Element do
  let(:user) { create(:user) }
  let(:parent_element) { create(:element, :user => user) }
  let!(:child_element) {
    element = create(:element, :user => user)
    parent_element.children << element
    element
  }

  it "has a default scope of unfinished" do
    child_element.update_attributes(:done => true)
    expect(Element.all).to eq [ parent_element ]
  end

  describe '#update_attributes' do
    it 'does not mass assign id' do
      new_id = UUIDTools::UUID.random_create.to_s
      parent_element.update_attributes(:id => new_id)
      expect(parent_element.id).not_to eq new_id
    end

    it 'does mass assign title' do
      parent_element.update_attributes(:title => 'wah!')
      expect(parent_element.title).to eq 'wah!'
    end

    it 'does mass assign starts_at' do
      new_time = Time.zone.parse('2012-05-10')
      parent_element.update_attributes(:starts_at => new_time)
      expect(parent_element.starts_at).to eq new_time
    end

    it 'does mass assign due_at' do
      new_time = Time.zone.parse('2012-05-10')
      parent_element.update_attributes(:due_at => new_time)
      expect(parent_element.due_at).to eq new_time
    end

    it 'does mass assign value' do
      parent_element.update_attribute(:value, 5)
      parent_element.update_attributes(:value => 9)
      expect(parent_element.value).to eq 9
    end

    it 'does mass assign urgency' do
      parent_element.update_attribute(:urgency, 5)
      parent_element.update_attributes(:urgency => 9)
      expect(parent_element.urgency).to eq 9
    end
  end

  describe '.roots' do
    it 'returns the top level elements' do
      expect(Element.roots).to eq [ parent_element ]
    end
  end

  describe '.leafs' do
    it 'returns leaf elements' do
      expect(Element.leafs).to eq [ child_element ]
    end
  end

  describe '.ranked' do
    context 'without paremeters' do
      it 'returns elements by rank in descending order' do
        parent_element.update_attributes(:value => 9)
        child_element.update_attributes(:value => 8)
        expect(Element.ranked).to eq [ parent_element, child_element ]
      end
    end

    context 'given :asc paremeter' do
      it 'returns elements by rank in ascending order' do
        parent_element.update_attributes(:value => 9)
        child_element.update_attributes(:value => 8)
        expect(Element.ranked(:asc)).to eq [ child_element, parent_element ]
      end
    end
  end

  describe '#update_rank' do
    context 'when element is saved' do
      it 'recalculates the rank for the element' do
        parent_element.update_attributes(:value => 9)
        expect(parent_element.rank).to eq 900
      end
    end
  end

  describe '#to_s' do
    it 'returns the title of the task' do
      expect(parent_element.to_s).to eq parent_element.title
    end
  end

  describe '#destroy' do
    context 'given an element with children' do
      it 'destroys child elements' do
        parent_element.destroy
        expect(Element.find_by_id(child_element.id)).to be_nil
      end
    end

    context 'given an element with a parent' do
      it 'does not destroy parent element' do
        child_element.destroy
        expect(Element.find_by_id(parent_element.id)).not_to be_nil
      end
    end
  end

  describe '#valid?' do
    let(:element) { Element.new(:title => 'do something') }

    context 'without a user' do
      it 'returns false' do
        expect(element).not_to be_valid
      end

      it 'has an error on user' do
        element.valid?
        expect(element.errors[:user]).to eq [ "can't be blank" ]
      end
    end
  end

  describe '#roots' do
    it 'returns elements only for that user' do
      user2 = FactoryGirl.create(:user)
      element1 = FactoryGirl.create(:element, :user => user2)
      options = { :user => user2, :parent => element1 }
      element2 = FactoryGirl.create(:element, options)
      expect(user2.elements.roots).to eq [ element1 ]
    end
  end

  describe '#leafs' do
    it 'returns elements only for that user' do
      user2 = FactoryGirl.create(:user)
      element1 = FactoryGirl.create(:element, :user => user2)
      options = { :user => user2, :parent => element1 }
      element2 = FactoryGirl.create(:element, options)
      expect(user2.elements.leafs).to eq [ element2 ]
    end

    it 'returns all elements if there are no parents' do
      user = FactoryGirl.create(:user)
      element = FactoryGirl.create(:element, :user => user)
      expect(user.elements.leafs).to eq [ element ]
    end
  end

  describe '#done' do
    context 'when set to true' do
      it 'sets done_at' do
        parent_element.done = true
        expect(parent_element.done_at).not_to be_nil
      end

      it 'marks child elements as done' do
        parent_element.done = true
        expect(child_element.reload.done_at).not_to be_nil
      end

      it 'does not mark parent elements as done' do
        child_element.done = true
        expect(parent_element.reload.done_at).to be_nil
      end
    end

    context 'when set to false' do
      it 'sets done_at back to nil' do
        parent_element.done = true
        parent_element.done = false
        expect(parent_element.done_at).to be_nil
      end
    end
  end
end
