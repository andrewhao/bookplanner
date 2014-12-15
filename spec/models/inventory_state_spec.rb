require "spec_helper"

describe InventoryState do
  subject { FactoryGirl.create :inventory_state }

  describe "#plan" do
    it "returns a Plan" do
      expect(subject.plan).to be_a Plan
    end
  end

  describe "#book_bags" do
    it "returns several book bags" do
      book_bags = FactoryGirl.create_list :book_bag, 2
      subject.book_bags += book_bags
      expect(subject.reload.book_bags).to eq book_bags
    end
  end
end
