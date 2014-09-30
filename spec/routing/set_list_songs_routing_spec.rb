require "spec_helper"

describe SetListSongsController do
  context "routing" do
    it "routes to #index" do
      get("/set_lists/1/songs").should route_to("set_list_songs#index", :set_list_id => "1")
    end

    it "routes to #create" do
      post("/set_lists/1/songs").should route_to("set_list_songs#create", :set_list_id => "1")
    end

    it "routes to #destroy" do
      delete("/set_lists/1/songs/2").should route_to("set_list_songs#destroy", :set_list_id => "1", :id => "2")
    end
  end
end

