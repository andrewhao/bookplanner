require 'spec_helper'

describe SetListsController do

  # This should return the minimal set of attributes required to create a valid
  # SetList. As you add validations to SetList, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { :title => "My Set List" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SetListsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all set_lists as @set_lists" do
      set_list = SetList.create! valid_attributes
      get :index, {:format => "json"}, valid_session
      assigns(:set_lists).should eq([set_list])
    end
  end

  describe "GET show" do
    it "assigns the requested set_list as @set_list" do
      set_list = SetList.create! valid_attributes
      get :show, {:id => set_list.to_param, :format => "json"}, valid_session
      assigns(:set_list).should eq(set_list)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SetList" do
        expect {
          post :create, {:set_list => valid_attributes, :format => "json"}, valid_session
        }.to change(SetList, :count).by(1)
      end

      it "assigns a newly created set_list as @set_list" do
        post :create, {:set_list => valid_attributes, :format => "json"}, valid_session
        assigns(:set_list).should be_a(SetList)
        assigns(:set_list).should be_persisted
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved set_list as @set_list" do
        # Trigger the behavior that occurs when invalid params are submitted
        SetList.any_instance.stub(:save).and_return(false)
        post :create, {:set_list => { :badparam => "hello" }, :format => "json"}, valid_session
        assigns(:set_list).should be_a_new(SetList)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested set_list" do
        set_list = SetList.create! valid_attributes
        # Assuming there are no other set_lists in the database, this
        # specifies that the SetList created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        SetList.any_instance.should_receive(:update).with({ "title" => "params" })
        put :update, {:id => set_list.to_param, :set_list => { "title" => "params" }, :format => "json"}, valid_session
      end

      it "assigns the requested set_list as @set_list" do
        set_list = SetList.create! valid_attributes
        put :update, {:id => set_list.to_param, :set_list => valid_attributes, :format => "json"}, valid_session
        assigns(:set_list).should eq(set_list)
      end
    end

    describe "with invalid params" do
      it "assigns the set_list as @set_list" do
        set_list = SetList.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SetList.any_instance.stub(:save).and_return(false)
        put :update, {:id => set_list.to_param, :set_list => { :badparam => "hello" }, :format => "json"}, valid_session
        assigns(:set_list).should eq(set_list)
      end
    end
  end

  describe "DELETE destroy" do
    let(:set_list) { SetList.create! valid_attributes }

    it "destroys the requested set_list" do
      set_list
      expect {
        delete :destroy, {:id => set_list.to_param, :format => "json"}, valid_session
      }.to change(SetList, :count).by(-1)
    end

    it "returns a 200 OK" do
      delete :destroy, {:id => set_list.to_param, :format => "json"}, valid_session
      response.should be_ok
    end
  end
end
