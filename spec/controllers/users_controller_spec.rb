require 'spec_helper'

describe UsersController do
  describe '#new' do
    before :each do
      get(:new)
    end

    it 'initializes an instance of User' do
      assigns(:user).should be_instance_of User
    end

    it "doesn't save the user record" do
      assigns(:user).should be_new_record
    end
  end

  describe '#create' do
    let(:valid_params) { {
      :username => 'billy',
      :email => 'b@b.com',
      :password => 'b',
      :password_confirmation => 'b',
    } }

    context 'given valid params' do
      before :each do
        post(:create, :user => valid_params)
      end

      it 'flashes a success message' do
        flash[:notice].should == 'Signed up!'
      end

      it 'creates a new user' do
        user = assigns(:user)
        user.username.should == 'billy'
      end

      it "logs the user in" do
        controller.send(:current_user).should == assigns(:user)
      end
    end

    context 'given an invalid email' do
      before :each do
        post(:create, :user => valid_params.merge(:password => 'c'))
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
