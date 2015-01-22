require 'spec_helper'

describe ApplicationController do
  let(:user) { create(:user) }

  describe '#current_user' do
    context 'when there is a user signed in' do
      before :each do
        session[:user_id] = user.id
      end

      it 'returns the user currently signed in' do
        expect(controller.send(:current_user)).to eq user
      end
    end

    context 'when there is not a user signed in' do
      it 'returns nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end

    context 'when there is an invalid session id' do
      before :each do
        session[:user_id] = 'blah'
      end

      it 'raises an exception' do
        expect {
          controller.send(:current_user)
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#current_user=' do
    it "clears the session" do
      session[:blah] = 'something'
      controller.send(:current_user=, user)
      expect(session[:blah]).to be_nil
    end

    it "sets the current user" do
      controller.send(:current_user=, user)
      expect(session[:user_id]).to eq user.id
    end
  end
end
