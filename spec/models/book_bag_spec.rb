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

  describe "#active?" do
    it "is true" do
      expect(subject).to be_active
    end
  end
end
