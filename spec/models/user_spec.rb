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

    it 'does not mass assign password_digest' do
      expect {
        @user.update_attributes(:password_digest => 'new_digest')
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      @user.password_digest.should_not == 'new_digest'
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

  describe '.authenticate' do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    context "when given valid credentials" do
      it "returns an instance of user" do
        User.authenticate(@user.email, @user.password).should == @user
      end
    end

    context "when given invalid password" do
      it "returns false" do
        User.authenticate(@user.email, "bad password").should be_false
      end
    end

    context "when given invalid email" do
      it "returns false" do
        User.authenticate("bad email", @user.password).should be_false
      end
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
end
