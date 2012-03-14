require 'spec_helper'

describe User do
  describe '#update_attributes' do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it 'does not mass assign id' do
      new_id = UUIDTools::UUID.random_create.to_s
      @user.update_attributes(:id => new_id)
      @user.id.should_not == new_id
    end

    it 'does not mass assign password_salt' do
      new_salt = BCrypt::Engine.generate_salt
      expect {
        @user.update_attributes(:password_salt => new_salt)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      @user.password_salt.should_not == new_salt
    end

    it 'does not mass assign password_hash' do
      expect {
        @user.update_attributes(:password_hash => 'new_hash')
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      @user.password_hash.should_not == 'new_hash'
    end

    it 'does not mass assign created_at' do
      old_time = Time.zone.now - 3.days
      new_time = Time.zone.now
      @user.update_attribute(:created_at, old_time)
      expect {
        @user.update_attributes(:created_at => new_time)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      @user.created_at.should == old_time
    end

    it 'does not mass assign updated_at' do
      new_time = Time.zone.now
      expect {
        @user.update_attributes(:updated_at => new_time)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      @user.updated_at.should_not == new_time
    end

    it 'does mass assign username' do
      @user.update_attributes(:username => 'wah!')
      @user.username.should == 'wah!'
    end

    it 'does mass assign email' do
      @user.update_attributes(:email => 'my@awesome.com')
      @user.email.should == 'my@awesome.com'
    end
  end

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
      @user = FactoryGirl.create(:user)
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
