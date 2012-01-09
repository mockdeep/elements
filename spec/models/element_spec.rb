require 'spec_helper'

describe Element do
  before :each do
    user = User.create(
      :email => 'a@a.com',
      :username => 'bob',
      :password => 'pizza',
      :password_confirmation => 'pizza',
    )

    @element1 = Element.create(:user => user, :title => 'do laundry')
    @element2 = Element.create(:user => user, :title => 'put clothes in washer')
    @element1.children << @element2
  end

  it 'should destroy child elements' do
    @element1.destroy
    Element.find_by_id(@element2.id).should be_nil
  end

  it 'should not destroy parent element' do
    @element2.destroy
    Element.find_by_id(@element1.id).should_not be_nil
  end

  it 'should require a user' do
    element = Element.new(:title => 'do something')
    element.should_not be_valid
    element.errors[:user].should == [ "can't be blank" ]
  end

  it 'should return root elements' do
    Element.root_elements.should == [ @element1 ]
  end

  it 'should return leaf elements' do
    pending
    Element.leafs.should == [ @element2 ]
  end

  it 'should mark elements as done' do
    pending
    @element1.done!
    @element1.should be_done
    @element1.done_at.should_not be_nil
  end

  it 'should return done status' do
    pending
    @element1.should_not be_done
    @element1.done!
    @element1.should be_done
  end

  it 'should undo' do
    pending
    @element1.done!
    @element1.should be_done
    @element1.undo
    @element1.should_not be_done
    @element1.done_at.should be_nil
  end

  it 'should mark child elements as done' do
    pending
    @element1.done!
    @element2.reload.should be_done
    @element2.done_at.should_not be_nil
  end

  # this test can be removed once satisfied
  it 'should not respond to done=' do
    pending
    @element1.should_not respond_to :done=
  end
end
