require 'spec_helper'

describe SessionsController do
  let(:user) { create(:user) }

  describe '#create' do
    context 'given valid credentials' do
      before :each do
        post(:create, :email => user.email, :password => user.password)
      end

      it 'sets the session user_id' do
        expect(session[:user_id]).to eq user.id
      end

      it 'flashes a success message' do
        expect(flash[:notice]).to eq 'Logged in!'
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'given invalid credentials' do
      before :each do
        post(:create, :email => user.email, :password => 'wrongpassword')
      end

      it 'sets the session user_id to nil' do
        expect(session[:user_id]).to be_nil
      end

      it 'flashes an error message' do
        expect(flash.now[:error]).to eq 'Invalid email or password'
      end

      it 'renders the new template' do
        expect(response).to render_template('sessions/new')
      end
    end
  end

  describe '#destroy' do
    before :each do
      session[:user_id] = user.id
      delete(:destroy)
    end

    it 'sets the session user_id to nil' do
      expect(session[:user_id]).to be_nil
    end

    it 'flashes a logged out message' do
      expect(flash[:notice]).to eq 'Logged out!'
    end

    it 'redirects to the root url' do
      expect(response).to redirect_to(root_url)
    end
  end
end
