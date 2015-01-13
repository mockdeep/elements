require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  describe '#update_attributes' do
    it 'does not mass assign id' do
      new_id = UUIDTools::UUID.random_create.to_s
      user.update_attributes(:id => new_id)
      user.id.should_not == new_id
    end

    it 'does mass assign username' do
      user.update_attributes(:username => 'wah!')
      user.username.should == 'wah!'
    end

    it 'does mass assign email' do
      user.update_attributes(:email => 'my@awesome.com')
      user.email.should == 'my@awesome.com'
    end
  end

  describe '.authenticate' do
    context "when given valid credentials" do
      it "returns an instance of user" do
        User.authenticate(user.email, user.password).should == user
      end
    end

    context "when given invalid password" do
      it "returns false" do
        User.authenticate(user.email, "bad password").should be false
      end
    end

    context "when given invalid email" do
      it "returns false" do
        User.authenticate("bad email", user.password).should be_nil
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
