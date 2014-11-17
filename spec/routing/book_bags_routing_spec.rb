require "spec_helper"

describe BookBagsController do
  describe "routing" do

    it "routes to #index" do
      get("/book_bags").should route_to("book_bags#index")
    end

    it "routes to #new" do
      get("/book_bags/new").should route_to("book_bags#new")
    end

    it "routes to #show" do
      get("/book_bags/1").should route_to("book_bags#show", :id => "1")
    end

    it "routes to #edit" do
      get("/book_bags/1/edit").should route_to("book_bags#edit", :id => "1")
    end

    it "routes to #create" do
      post("/book_bags").should route_to("book_bags#create")
    end

    it "routes to #update" do
      put("/book_bags/1").should route_to("book_bags#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/book_bags/1").should route_to("book_bags#destroy", :id => "1")
    end

  end
end
