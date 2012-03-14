require 'spec_helper'

describe UsersController do
  describe '#new' do
    before :each do
      get(:new)
      @user = assigns(:user)
    end

    it 'initializes an instance of User' do
      @user.should be_instance_of User
    end

    it "doesn't save the user record" do
      @user.should be_new_record
    end
  end

  describe '#create' do
    before :each do
      @valid_params = {
        :username => 'billy',
        :email => 'b@b.com',
        :password => 'b',
        :password_confirmation => 'b',
      }
    end

    context 'given valid params' do
      before :each do
        post(:create, :user => @valid_params)
      end

      it 'flashes a success message' do
        flash[:notice].should == 'Signed up!'
      end

      it 'creates a new user' do
        user = assigns(:user)
        user.username.should == 'billy'
      end
    end

    context 'without params' do
      before :each do
        post(:create)
      end

      it 'flashes an error' do
        flash.now[:error].should =~ /problem creating your account/
      end

      it 'renders the new template' do
        response.should render_template('users/new')
      end
    end

    context 'given an invalid email' do
      before :each do
        post(:create, :user => @valid_params.merge(:password => 'c'))
      end

      it 'flashes an error' do
        flash.now[:error].should =~ /problem creating your account/
      end

      it 'renders the new template' do
        response.should render_template('users/new')
      end
    end
  end
end
