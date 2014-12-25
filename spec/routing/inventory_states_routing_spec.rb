require "spec_helper"

describe InventoryStatesController do
  describe "routing" do
    it "routes to #new on classroom resource" do
      get("/classrooms/1/inventory_states/new").should route_to("inventory_states#new", classroom_id: "1")
    end

    it "routes to #show" do
      get("/inventory_states/1").should route_to("inventory_states#show", id: "1")
    end

    it "routes to #create on classroom resource" do
      post("/classrooms/1/inventory_states").should route_to("inventory_states#create", classroom_id: "1")
    end

    it "routes to #edit on classroom resource" do
      get("/inventory_states/1/edit").should route_to("inventory_states#edit", id: "1")
    end
  end
end

