require 'spec_helper'

describe UUIDHelper do
  describe '.included' do
    context 'when loaded into class' do
      before :each do
        @element = FactoryGirl.create(:element)
      end

      it "doesn't allow writing to the id" do
        id = @element.id
        @element.id = 'blah'
        @element.save!
        Element.find(id).should_not be_nil
      end

      it 'sets the uuid before create' do
        @element.id.should =~ /^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$/
      end
    end
  end
end