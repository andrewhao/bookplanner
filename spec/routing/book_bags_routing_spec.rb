require "spec_helper"

describe BookBagsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/book_bags")).to route_to("book_bags#index")
    end

    it "routes to #index on classroom resource" do
      expect(get("/classrooms/1/book_bags")).to route_to("book_bags#index", classroom_id: "1")
    end

    it "routes to #new on classroom resource" do
      expect(get("/classrooms/1//book_bags/new")).to route_to("book_bags#new", classroom_id: "1")
    end

    it "routes to #show" do
      expect(get("/book_bags/1")).to route_to("book_bags#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/book_bags/1/edit")).to route_to("book_bags#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/book_bags")).to route_to("book_bags#create")
    end

    it "routes to #update" do
      expect(put("/book_bags/1")).to route_to("book_bags#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/book_bags/1")).to route_to("book_bags#destroy", :id => "1")
    end

  end
end
