require 'spec_helper'

describe UsersController do
  describe :new do
    it 'should assign a blank user' do
      get :new
      user = assigns(:user)
      user.should be_instance_of User
      user.should be_new_record
      user.email.should be_blank
      user.username.should be_blank
      user.password.should be_blank
      user.password_confirmation.should be_blank
    end
  end

  describe :create do
    before :each do
      @valid_params = {
        :username => 'billy',
        :email => 'b@b.com',
        :password => 'b',
        :password_confirmation => 'b',
      }
    end

    it 'should create a new user' do
      post :create, :user => @valid_params
      flash[:notice].should == 'Signed up!'
      user = assigns(:user)
      user.username.should == 'billy'
    end

    it 'should render error when missing params' do
      post :create
      flash.now[:error].should =~ /problem creating your account/
    end

    it 'should render error for invalid params' do
      post :create, :user => @valid_params.merge(:password => 'c')
      flash.now[:error].should =~ /problem creating your account/
      assigns(:user).errors.full_messages.first.should =~ /doesn't match/
      post :create, :user => @valid_params.merge(:email => 'b')
      flash.now[:error].should =~ /problem creating your account/
      assigns(:user).errors.full_messages.first.should =~ /Email is invalid/
    end
  end
end
