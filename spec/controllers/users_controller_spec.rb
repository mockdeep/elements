require 'spec_helper'

describe UsersController do
  describe '#new' do
    before :each do
      get(:new)
    end

    it 'initializes an instance of User' do
      expect(assigns(:user)).to be_instance_of User
    end

    it "doesn't save the user record" do
      expect(assigns(:user)).to be_new_record
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
        expect(flash[:notice]).to eq 'Signed up!'
      end

      it 'creates a new user' do
        user = assigns(:user)
        expect(user.username).to eq 'billy'
      end

      it "logs the user in" do
        expect(controller.send(:current_user)).to eq assigns(:user)
      end
    end

    context 'given an invalid email' do
      before :each do
        post(:create, :user => valid_params.merge(:password => 'c'))
      end

      it 'flashes an error' do
        expect(flash.now[:error]).to match /problem creating your account/
      end

      it 'renders the new template' do
        expect(response).to render_template('users/new')
      end
    end
  end
end
