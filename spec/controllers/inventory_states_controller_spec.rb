require "spec_helper"

describe InventoryStatesController do
  let(:classroom) { FactoryGirl.create :classroom }

  describe "#new" do
    it "renders new template" do
      get :new, classroom_id: classroom.id
      expect(response).to render_template("new")
    end

    it "assigns the classroom" do
      get :new, classroom_id: classroom.id
      expect(assigns(:classroom)).to eq classroom
    end
  end

  describe "#create" do
    it "makes a new IS" do
    end
  end
end
