require "spec_helper"

describe Period do
  subject { plan.period }
  let(:classroom) { plan.classroom }
  let(:plan) { FactoryGirl.create :plan_with_assignments }

  before do
    plan
  end

  describe "initialization" do
    let(:name)  { "Week Six" }

    it "prepopulates name to the current time" do
      expect(described_class.new.name).to eq Date.today.to_s
    end

    it "does not prepopulate if the name already exists" do
      subject.update_attributes(name: name)
      expect(subject.name).to eq name
    end
  end

  describe "#periods_from" do
    before(:each) do
      plans = FactoryGirl.create_list :plan_with_assignments, 3, classroom: classroom
      plans.sort_by!(&:id)
      @older, @old, @new = plans.map(&:period)
    end

    it "throws exception if nil" do
      expect {
        subject.periods_from(nil)
      }.to raise_error
    end

    it "returns 0 for identity" do
      expect(subject.periods_from(subject)).to eq 0
    end

    it "returns 1 for one older period" do
      expect(@new.periods_from(@old)).to eq 1
    end

    it "returns 2 for two period gap" do
      expect(@new.periods_from(@older)).to eq 2
    end

    it "returns -1 for newer period" do
      expect(@old.periods_from(@new)).to eq -1
    end
  end
end
