require "spec_helper"

describe InventoryStatesController do
  let(:classroom) { FactoryGirl.create :classroom }
  let(:period) { FactoryGirl.create :period, classroom: classroom }
  let(:plan) { FactoryGirl.create :plan_with_assignments, period: period }

  before do
    plan
    period
  end

  describe "#new" do
    it "renders new template" do
      get :new, classroom_id: classroom.id
      expect(response).to render_template("new")
    end

    it "assigns the classroom" do
      get :new, classroom_id: classroom.id
      expect(assigns(:classroom)).to eq classroom
    end

    it "assigns the plan" do
      get :new, classroom_id: classroom.id
      expect(assigns(:plan)).to eq plan
    end
  end

  describe "#create" do
    let(:post_params) do
      { inventory_state: {
        classroom_id: classroom.id.to_s
        }}.deep_stringify_keys!
    end

    it "passes params to ISG" do
      mock_generator = instance_double("InventoryStateGenerator", success?: true, generate: nil, classroom: classroom)
      expect(InventoryStateGenerator).to receive(:new).with(hash_including(post_params)).and_return(mock_generator)
      post :create, post_params
    end
  end

  describe "#destroy" do
    let(:inventory_state) { FactoryGirl.create :inventory_state, period: period }

    it "deletes the InventoryState" do
      inventory_state
      expect {
        delete :destroy, id: inventory_state.id
      }.to change{ InventoryState.count }.by(-1)
    end

    it "redirects to the existing classroom page" do
      classroom = inventory_state.classroom
      delete :destroy, id: inventory_state.id
      expect(response).to redirect_to classroom_path(classroom)
    end
  end
end
