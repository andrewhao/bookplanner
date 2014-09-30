require 'spec_helper'

describe Plan do
  subject { FactoryGirl.create(:plan) }
  describe "#assignments" do
    it "returns a list of assignments" do
      expect(subject.assignments).to eq []
    end
  end
end
