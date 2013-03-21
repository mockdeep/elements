require 'spec_helper'

describe ElementsController do
  render_views
  let(:element1) { create(:element) }
  let(:user) { element1.user }
  let(:element2) { create(:element, :parent => element1, :user => user) }

  before :each do
    session[:user_id] = user.id
  end

  describe '#index' do
    context 'when user is not logged in' do
      it 'redirects to login page' do
        session[:user_id] = nil
        get(:index)
        should redirect_to(login_path)
      end
    end

    context 'with no parameters' do
      it 'assigns root elements' do
        get(:index)
        assigns(:elements).should == [ element1 ]
      end
    end

    context "given 'ranked' parameter" do
      it 'assigns ranked leaf elements' do
        element2.update_attribute(:value, 8)
        element3 = create(:element, :user => user, :value => 9)
        get(:index, :view => 'ranked')
        assigns(:elements).should == [ element3, element2 ]
      end
    end
  end

  describe '#new' do
    context 'without a parent_id' do
      before :each do
        get(:new)
      end

      it 'initializes an element' do
        assigns(:element).should be_new_record
      end

      it 'builds an element without a parent' do
        assigns(:element).parent.should be_nil
      end
    end

    context 'given a parent_id' do
      it 'builds an element with a parent' do
        get(:new, :parent_id => element1.id)
        assigns(:element).parent.should == element1
      end
    end
  end

  describe '#create' do
    context 'without a parent_id' do
      before :each do
        post(:create, :element => { :title => 'do stuff' })
      end

      it 'creates the element for the current user' do
        user.elements.should include assigns(:element)
      end

      it 'assigns the title of the element' do
        assigns(:element).title.should == 'do stuff'
      end

      it 'saves the element' do
        assigns(:element).should_not be_new_record
      end

      it 'creates an element without a parent' do
        assigns(:element).parent.should be_nil
      end

      it 'flashes a success notice' do
        flash[:notice].should =~ /created successfully/
      end
    end

    context 'given a parent id' do
      before :each do
        post(:create,
          :parent_id => element2,
          :element => {
            :title => 'do more stuff',
          }
        )
      end

      it 'creates an element for the current user' do
        user.elements.should include assigns(:element)
      end

      it 'assigns the title of the element' do
        assigns(:element).title.should == 'do more stuff'
      end

      it 'saves the element' do
        assigns(:element).should_not be_new_record
      end

      it 'flashes a success notice' do
        flash[:notice].should =~ /created successfully/
      end

      it 'creates an element with a parent' do
        element2.children.should == [ assigns(:element) ]
      end
    end

    context 'given invalid attributes' do
      it 'gives an error' do
        post(:create, :element => { :title => '' })
        flash.now[:error].should =~ /problem creating/
      end
    end
  end

  describe '#edit' do
    context 'given a valid element id' do
      it 'finds the appropriate element' do
        get(:edit, :id => element1.id)
        assigns(:element).should == element1
      end
    end
  end

  describe '#update' do
    context 'given valid attributes' do
      before :each do
        put(:update, :id => element1.id, :element => { :title => 'blah' })
      end

      it 'updates the element' do
        element1.reload.title.should == 'blah'
      end

      it 'flashes a success notice' do
        flash[:notice].should =~ /updated successfully/
      end
    end

    context 'given invalid attributes' do
      before :each do
        @title = element1.title
        put(:update, :id => element1.id, :element => { :title => nil })
      end

      it 'does not change the element title' do
        element1.reload.title.should == @title
      end

      it 'flashes an error notice' do
        flash.now[:error].should =~ /problem updating/
      end
    end
  end

  describe '#destroy' do
    context 'given a valid element id' do
      before :each do
        delete(:destroy, :id => element1.id)
      end

      it 'destroys the element' do
        Element.find_by_id(element1.id).should be_nil
      end

      it 'flashes a deleted notice' do
        flash[:notice].should =~ /Element deleted/
      end
    end

    context 'given the id of an element from another user' do
      before :each do
        user2 = FactoryGirl.create(:user)
        session[:user_id] = user2.id
      end

      it 'raises a RecordNotFound exception' do
        expect {
          delete(:destroy, :id => element1.id)
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'does not destroy the element' do
        lambda { delete(:destroy, :id => element1.id) }
        Element.find_by_id(element1.id).should_not be_nil
      end
    end
  end
end
