require "spec_helper"

describe Song do
  let(:song) { Song.create :title => "start spangled banner" }
  let(:set_list) { SetList.create :title => "Yo yo" }

  context "associations" do
    it "has many set_lists" do
      song.set_lists << set_list

      song.reload.set_lists.should == [set_list]
    end

    it "can build set_lists" do
      expect {
        song.set_lists << SetList.create(:title => "yo")
      }.to change{ song.reload.set_lists.count }.by(1)
    end

    it "rejects duplicate set lists" do
      song.set_lists << set_list
      expect {
        song.set_lists << set_list
      }.to raise_error
    end
  end
end
