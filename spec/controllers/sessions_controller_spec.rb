require 'spec_helper'

describe SessionsController do
  before :each do
    @user = Factory(:user)
  end

  describe '#create' do
    context 'given valid credentials' do
      before :each do
        post(:create, :email => @user.email, :password => @user.password)
      end

      it 'sets the session user_id' do
        session[:user_id].should == @user.id
      end

      it 'flashes a success message' do
        flash[:notice].should == 'Logged in!'
      end

      it 'redirects to elements#index' do
        response.should redirect_to(elements_index_path)
      end
    end

    context 'given invalid credentials' do
      before :each do
        post(:create, :email => @user.email, :password => 'wrongpassword')
      end

      it 'sets the session user_id to nil' do
        session[:user_id].should be_nil
      end

      it 'flashes an error message' do
        flash.now[:error].should == 'Invalid email or password'
      end

      it 'renders the new template' do
        response.should render_template('sessions/new')
      end
    end
  end

  describe '#destroy' do
    before :each do
      session[:user_id] = @user.id
      delete(:destroy)
    end

    it 'sets the session user_id to nil' do
      session[:user_id].should be_nil
    end

    it 'flashes a logged out message' do
      flash[:notice].should == 'Logged out!'
    end

    it 'redirects to the root url' do
      response.should redirect_to(root_url)
    end
  end
end
