require 'spec_helper'

describe User do
  describe '#elements' do
    it { should have_many :elements }
  end

  describe '#valid?' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :username }
    it { should validate_presence_of :password }
  end

  describe '#encrypt_password' do
    before :each do
      @user = User.new
    end

    context 'when password is blank' do
      it 'does nothing' do
        @user.encrypt_password
        @user.password_hash.should be_nil
      end
    end

    context 'when password is given' do
      before :each do
        @user.password = 'blah'
        @user.password_confirmation = 'blah'
        @user.encrypt_password
      end

      it 'generates a password salt' do
        @user.password_salt.should_not be_nil
      end

      it 'encrypts password' do
        hash = BCrypt::Engine.hash_secret('blah', @user.password_salt)
        @user.password_hash.should == hash
      end
    end
  end

  describe '#authenticate' do
    before :each do
      @user = Factory(:user)
    end

    context 'given valid credentials' do
      it 'returns the user object' do
        User.authenticate(@user.email, @user.password).should == @user
      end
    end

    context 'given a bad password' do
      it 'returns nil' do
        User.authenticate(@user.email, 'nonsense').should be_nil
      end
    end

    context 'given a non-existent email' do
      it 'returns nil' do
        User.authenticate('nonsense', @user.password).should be_nil
      end
    end
  end
end
