require "spec_helper"

describe InventoryStatesController do
  describe "routing" do
    it "routes to #new on classroom resource" do
      expect(get("/classrooms/1/inventory_states/new")).to route_to("inventory_states#new", classroom_id: "1")
    end

    it "routes to #show" do
      expect(get("/inventory_states/1")).to route_to("inventory_states#show", id: "1")
    end

    it "routes to #create" do
      expect(post("/inventory_states")).to route_to("inventory_states#create")
    end

    it "routes to #destroy" do
      expect(delete("/inventory_states/1")).to route_to("inventory_states#destroy", id: "1")
    end
  end
end

