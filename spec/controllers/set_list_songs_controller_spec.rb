require "spec_helper"

describe SetListSongsController do
  let(:set_list) { FactoryGirl.create :set_list, :songs => songs }
  let(:song) { FactoryGirl.create :song }
  let(:songs) { [song] }

  describe "#index" do
    it "returns the songs associated with the set list" do
      get :index, :set_list_id => set_list.id, :format => "json"
      assigns(:songs).should == songs
    end

    it "returns an empty array if no songs are in the set list" do
      empty_set = FactoryGirl.create :set_list
      get :index, :set_list_id => empty_set.id, :format => "json"
      assigns(:songs).should == []
    end

    it "returns 404 if the set list does not exist" do
      expect {
        get :index, :set_list_id => SetList.count + 1, :format => "json"
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "#create" do
    let(:songs) {[]}

    before do
      song
      set_list
    end

    it "associates the song with the set list" do
      # for some reason, the expect{}.to change{} syntax doesn't work here.
      set_list.songs.should be_empty
      post :create, :set_list_id => set_list.id, :id => song.id, :format => "json"
      set_list.reload.songs.should == [song]
    end

    it "does not actually create a new record" do
      expect {
        post :create, :set_list_id => set_list.id, :id => song.id, :format => "json"
      }.to_not change{ Song.count }
    end
    
    it "returns a CREATED status" do
      post :create, :set_list_id => set_list.id, :id => song.id, :format => "json"
      response.should be_success
    end
  end

  describe "#destroy" do
    before do
      song
    end

    it "deletes the song association from the set list" do
      expect {
        delete :destroy, :set_list_id => set_list.id, :id => song.id
      }.to change{ set_list.reload.songs.count }.by(-1) &&
        change{ Song.count }.by(0)
    end
  end
end
