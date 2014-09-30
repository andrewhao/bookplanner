require "spec_helper"

describe SetListsController do
  describe "routing" do

    it "routes to #index" do
      get("/set_lists").should route_to("set_lists#index")
    end

    it "routes to #new" do
      get("/set_lists/new").should route_to("set_lists#new")
    end

    it "routes to #show" do
      get("/set_lists/1").should route_to("set_lists#show", :id => "1")
    end

    it "routes to #edit" do
      get("/set_lists/1/edit").should route_to("set_lists#edit", :id => "1")
    end

    it "routes to #create" do
      post("/set_lists").should route_to("set_lists#create")
    end

    it "routes to #update" do
      put("/set_lists/1").should route_to("set_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/set_lists/1").should route_to("set_lists#destroy", :id => "1")
    end
  end
end
