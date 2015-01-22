require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  describe '#update_attributes' do
    it 'does not mass assign id' do
      new_id = UUIDTools::UUID.random_create.to_s
      user.update_attributes(:id => new_id)
      expect(user.id).not_to eq new_id
    end

    it 'does mass assign username' do
      user.update_attributes(:username => 'wah!')
      expect(user.username).to eq 'wah!'
    end

    it 'does mass assign email' do
      user.update_attributes(:email => 'my@awesome.com')
      expect(user.email).to eq 'my@awesome.com'
    end
  end

  describe '.authenticate' do
    context "when given valid credentials" do
      it "returns an instance of user" do
        expect(User.authenticate(user.email, user.password)).to eq user
      end
    end

    context "when given invalid password" do
      it "returns false" do
        expect(User.authenticate(user.email, "bad password")).to be false
      end
    end

    context "when given invalid email" do
      it "returns false" do
        expect(User.authenticate("bad email", user.password)).to be_nil
      end
    end
  end

  describe '#elements' do
    it { is_expected.to have_many :elements }
  end

  describe '#valid?' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_presence_of :password }
  end
end
