require 'spec_helper'

describe Plan do
  subject { FactoryGirl.create(:plan) }

  describe "#assignments" do
    it "returns a list of assignments" do
      expect(subject.assignments).to be_all{|a| a.is_a?(Assignment)}
    end
  end
end
