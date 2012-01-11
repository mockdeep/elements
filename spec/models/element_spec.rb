require 'spec_helper'

describe Element do
  before :each do
    user = User.create(
      :email => 'a@a.com',
      :username => 'bob',
      :password => 'pizza',
      :password_confirmation => 'pizza',
    )

    @parent_element = Element.create(:user => user, :title => 'do laundry')
    @child_element = Element.create(
      :user => user,
      :title => 'put clothes in washer'
    )
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
    Element.root_elements.should == [ @parent_element ]
  end

  it 'should return leaf elements' do
    pending
    Element.leafs.should == [ @child_element ]
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
