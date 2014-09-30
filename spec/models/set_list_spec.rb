require "spec_helper"

describe SetList do
  let(:set_list) { SetList.create :title => "cool set" }
  let(:song) { Song.create :title => "cool song" }

  context "associations" do
    it 'has many songs' do
      set_list.songs << song

      set_list.reload.songs.should == [song]
    end

    it "has only unique songs" do
      set_list.songs << song

      expect {
        set_list.songs << song
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
