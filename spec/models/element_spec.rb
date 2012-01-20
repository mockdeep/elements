require 'spec_helper'

describe Element do
  before :each do
    @user = Factory(:user)
    @parent_element = Factory(:element, :user => @user)
    @child_element = Factory(:element, :user => @user)
    @parent_element.children << @child_element
  end

  it 'should destroy child elements' do
    @parent_element.destroy
    Element.find_by_id(@child_element.id).should be_nil
  end

  it 'should not destroy parent element' do
    @child_element.destroy
    Element.find_by_id(@parent_element.id).should_not be_nil
  end

  it 'should require a user' do
    element = Element.new(:title => 'do something')
    element.should_not be_valid
    element.errors[:user].should == [ "can't be blank" ]
  end

  it 'should return root elements' do
    Element.roots.should == [ @parent_element ]
  end

  it 'should return leaf elements' do
    Element.leafs.should == [ @child_element ]
  end

  it 'should not return elements for another user' do
    user2 = Factory(:user)
    element1 = Factory(:element, :user => user2)
    element2 = Factory(:element, :user => user2, :parent => element1)

    user2.elements.roots.should == [ element1 ]
    user2.elements.leafs.should == [ element2 ]
    @user.elements.roots.should == [ @parent_element ]
    @user.elements.leafs.should == [ @child_element ]
  end

  it 'should mark elements as done' do
    @parent_element.done_at.should be_nil
    @parent_element.done = true
    @parent_element.done_at.should_not be_nil
  end

  it 'should undo' do
    @parent_element.done = true
    @parent_element.done_at.should_not be_nil
    @parent_element.done = false
    @parent_element.done_at.should be_nil
  end

  it 'should mark child elements as done' do
    @child_element.done_at.should be_nil
    @parent_element.done = true
    @child_element.done_at.should_not be_nil
  end

  it 'should not mark parent elements as done' do
    @parent_element.done_at.should be_nil
    @child_element.done = true
    @parent_element.reload.done_at.should be_nil
  end
end
