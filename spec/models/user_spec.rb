require 'spec_helper'

describe User do
  it { should have_many :elements }
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }
  it { should validate_presence_of :password }

  describe 'password encryption' do
    before :each do
      @user = User.new
    end

    it 'should do nothing if password is blank' do
      @user.encrypt_password
      @user.password_salt.should be_nil
      @user.password_hash.should be_nil
      @user.password.should be_nil
    end

    it 'should encrypt if password is given' do
      @user.password = 'blah'
      @user.password_confirmation = 'blah'
      @user.encrypt_password

      @user.password_salt.should_not be_nil
      hash = BCrypt::Engine.hash_secret('blah', @user.password_salt)
      @user.password_hash.should == hash
    end
  end

  describe 'authentication' do
    before :each do
      @user = Factory(:user)
    end

    it 'should return the user given valid credentials' do
      User.authenticate(@user.email, @user.password).should == @user
    end

    it 'should return nil given bad password' do
      User.authenticate(@user.email, 'nonsense').should be_nil
    end

    it 'should return nil given non-existent email' do
      User.authenticate('nonsense', @user.password).should be_nil
    end
  end
end
