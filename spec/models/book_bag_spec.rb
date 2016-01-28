require 'spec_helper'

describe BookBag do
  subject { FactoryGirl.create :book_bag, global_id: 1, classroom_id: 1 }

  context "uniqueness constraints" do
    before do
      FactoryGirl.create :book_bag, global_id: 1, classroom_id: 1
    end

    it "does not allow dupe global ids" do
      expect {
        FactoryGirl.create :book_bag, global_id: 1, classroom_id: 1
      }.to raise_error
    end

    it "allows different global ids with diff classrooms" do
      bag = FactoryGirl.create :book_bag, global_id: 1, classroom_id: 2
      expect(bag).to be_valid
      expect(bag).to be_persisted
    end
  end

  describe ".active" do
    it "returns a list of active book bags" do
      actives = FactoryGirl.create_list :book_bag, 2,  active: true
      inactives = FactoryGirl.create_list :book_bag, 2, active: false

      expect(described_class.active).to match_array actives
    end
  end

  describe '.by_global_id' do
    it 'sorts bags by global ID' do
      b1 = create(:book_bag, global_id: "10")
      b2 = create(:book_bag, global_id: "1")

      expect(described_class.by_global_id).to eq [b2, b1]
    end
  end
end
