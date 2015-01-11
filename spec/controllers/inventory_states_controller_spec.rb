require "spec_helper"

describe InventoryStatesController do
  let(:classroom) { FactoryGirl.create :classroom }
  let(:plan) { FactoryGirl.create :plan_with_assignments, classroom: classroom }

  before do
    plan
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
      {
        inventory_state: {
          classroom_id: classroom.id
        }
      }
    end

    it "makes a new IS" do
      expect {
        post :create, post_params
      }.to change(InventoryState, :count).by(1)
    end

    it "assigns IS with correct params" do
      post :create, post_params
      expect(assigns(:inventory_state).period).to eq plan.period
    end
  end
end
