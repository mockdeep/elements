require 'spec_helper'

describe ElementsController do
  before :each do
    @element1 = Factory(:element)
    @user = @element1.user
    @element2 = Factory(:element, :parent => @element1, :user => @user)
    session[:user_id] = @user.id
  end

  describe :index do
    it 'should redirect to login page if not logged in' do
      pending
      session[:user_id] = nil
      get :index
      should redirect_to login_path
    end

    it 'should return root elements by default' do
      get :index
      assigns(:elements).should == [ @element1 ]
      assigns(:tree).should be_nil
    end


    it 'should return leaf elements' do
      get :index, :tree => :leafs
      assigns(:elements).should == [ @element2 ]
      assigns(:tree).should == 'leafs'
    end
  end

  describe :new do
    it 'should build an element without a parent' do
      get :new
      element = assigns(:element)
      element.parent.should be_nil
      element.should be_new_record
    end

    it 'should build an element with a parent' do
      get :new, :parent_id => @element1.id
      assigns(:element).parent.should == @element1
    end
  end

  describe :create do
    it 'should create an element without a parent' do
      post :create, :element => { :title => 'do stuff' }
      element = assigns(:element)
      @user.elements.should include element
      element.title.should == 'do stuff'
      element.should_not be_new_record
      flash[:notice].should =~ /created successfully/
    end

    it 'should create an element with a parent' do
      post :create, :element => {
        :title => 'do more stuff',
        :parent_id => @element2
      }
      element = assigns(:element)
      @user.elements.should include element
      element.title.should == 'do more stuff'
      element.should_not be_new_record
      flash[:notice].should =~ /created successfully/
      @element2.children.should == [ element ]
    end

    it 'should give an error for invalid attributes' do
      post :create
      flash.now[:error].should =~ /problem creating/
    end
  end

  describe :edit do
    it 'should find the appropriate element' do
      get :edit, :id => @element1.id
      assigns(:element).should == @element1
    end
  end

  describe :update do
    it 'should update an element' do
      put :update, :id => @element1.id, :element => { :title => 'blah' }
      @element1.reload.title.should == 'blah'
      flash[:notice].should =~ /updated successfully/
    end

    it 'should render an error for invalid attributes' do
      title = @element1.title
      put :update, :id => @element1.id, :element => { :title => nil }
      @element1.reload.title.should == title
      flash.now[:error].should =~ /problem updating/
    end
  end

  describe :destroy do
    it 'should destroy an element' do
      delete :destroy, :id => @element1.id
      Element.find_by_id(@element1.id).should be_nil
      flash[:notice].should =~ /Element deleted/
    end

    it 'should not destroy another users element' do
      user2 = Factory(:user)
      session[:user_id] = user2.id

      lambda {
        delete :destroy, :id => @element1.id
      }.should raise_error ActiveRecord::RecordNotFound
      Element.find_by_id(@element1.id).should_not be_nil
    end
  end
end
