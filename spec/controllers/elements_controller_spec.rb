require 'spec_helper'

describe ElementsController do
  let(:element1) { create(:element) }
  let(:user) { element1.user }
  let(:element2) { create(:element, :parent => element1, :user => user) }

  before :each do
    session[:user_id] = user.id
  end

  describe '#index' do
    context 'when user is not logged in' do
      it 'redirects to login page' do
        session[:user_id] = nil
        get(:index)
        should redirect_to(login_path)
      end
    end

    context 'with no parameters' do
      it 'assigns root elements' do
        get(:index)
        expect(assigns(:elements)).to eq [ element1 ]
      end
    end

    context "given 'ranked' parameter" do
      it 'assigns ranked leaf elements' do
        element2.update_attribute(:value, 8)
        element3 = create(:element, :user => user, :value => 9)
        get(:index, :view => 'ranked')
        expect(assigns(:elements)).to eq [ element3, element2 ]
      end
    end
  end

  describe '#new' do
    context 'without a parent_id' do
      before :each do
        get(:new)
      end

      it 'initializes an element' do
        expect(assigns(:element)).to be_new_record
      end

      it 'builds an element without a parent' do
        expect(assigns(:element).parent).to be_nil
      end
    end

    context 'given a parent_id' do
      it 'builds an element with a parent' do
        get(:new, :parent_id => element1.id)
        expect(assigns(:element).parent).to eq element1
      end
    end
  end

  describe '#create' do
    context 'without a parent_id' do
      before :each do
        post(:create, :element => { :title => 'do stuff' })
      end

      it 'creates the element for the current user' do
        expect(user.elements).to include assigns(:element)
      end

      it 'assigns the title of the element' do
        expect(assigns(:element).title).to eq 'do stuff'
      end

      it 'saves the element' do
        expect(assigns(:element)).not_to be_new_record
      end

      it 'creates an element without a parent' do
        expect(assigns(:element).parent).to be_nil
      end

      it 'flashes a success notice' do
        expect(flash[:notice]).to match /created successfully/
      end
    end

    context 'given a parent id' do
      before :each do
        post(:create,
          :parent_id => element2,
          :element => {
            :title => 'do more stuff',
          }
        )
      end

      it 'creates an element for the current user' do
        expect(user.elements).to include assigns(:element)
      end

      it 'assigns the title of the element' do
        expect(assigns(:element).title).to eq 'do more stuff'
      end

      it 'saves the element' do
        expect(assigns(:element)).not_to be_new_record
      end

      it 'flashes a success notice' do
        expect(flash[:notice]).to match /created successfully/
      end

      it 'creates an element with a parent' do
        expect(element2.children).to eq [ assigns(:element) ]
      end
    end

    context 'given invalid attributes' do
      it 'gives an error' do
        post(:create, :element => { :title => '' })
        expect(flash.now[:error]).to match /problem creating/
      end
    end
  end

  describe '#edit' do
    context 'given a valid element id' do
      it 'finds the appropriate element' do
        get(:edit, :id => element1.id)
        expect(assigns(:element)).to eq element1
      end
    end
  end

  describe '#update' do
    context 'given valid attributes' do
      before :each do
        put(:update, :id => element1.id, :element => { :title => 'blah' })
      end

      it 'updates the element' do
        expect(element1.reload.title).to eq 'blah'
      end

      it 'flashes a success notice' do
        expect(flash[:notice]).to match /updated successfully/
      end
    end

    context 'given invalid attributes' do
      before :each do
        @title = element1.title
        put(:update, :id => element1.id, :element => { :title => nil })
      end

      it 'does not change the element title' do
        expect(element1.reload.title).to eq @title
      end

      it 'flashes an error notice' do
        expect(flash.now[:error]).to match /problem updating/
      end
    end
  end

  describe '#destroy' do
    context 'given a valid element id' do
      before :each do
        delete(:destroy, :id => element1.id)
      end

      it 'destroys the element' do
        expect(Element.find_by_id(element1.id)).to be_nil
      end

      it 'flashes a deleted notice' do
        expect(flash[:notice]).to match /Element deleted/
      end
    end

    context 'given the id of an element from another user' do
      before :each do
        user2 = FactoryGirl.create(:user)
        session[:user_id] = user2.id
      end

      it 'raises a RecordNotFound exception' do
        expect {
          delete(:destroy, :id => element1.id)
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it 'does not destroy the element' do
        lambda { delete(:destroy, :id => element1.id) }
        expect(Element.find_by_id(element1.id)).not_to be_nil
      end
    end
  end
end
