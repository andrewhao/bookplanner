require "spec_helper"

describe InventoryStatesController do
  let(:classroom) { FactoryGirl.create :classroom }
  let(:plan) { FactoryGirl.create :plan_with_assignments, classroom: classroom }

  describe "#new" do
    before do
      plan
    end

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
    it "makes a new IS" do
    end
  end
end
