require 'spec_helper'

describe ApplicationController do
  describe '#current_user' do
    context 'when there is a user signed in' do
      before :each do
        @user = FactoryGirl.create(:user)
        session[:user_id] = @user.id
      end

      it 'returns the user currently signed in' do
        controller.send(:current_user).should == @user
      end
    end

    context 'when there is not a user signed in' do
      it 'returns nil' do
        controller.send(:current_user).should be_nil
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
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it "clears the session" do
      session[:blah] = 'something'
      controller.send(:current_user=, @user)
      session[:blah].should be_nil
    end

    it "sets the current user" do
      controller.send(:current_user=, @user)
      session[:user_id].should == @user.id
    end
  end
end
