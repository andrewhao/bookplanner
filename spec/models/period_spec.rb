require "spec_helper"

describe Period do
  subject { FactoryGirl.create :period }
  let(:plan) { FactoryGirl.create :plan_with_assignments, period: subject }
  let(:classroom) { subject.classroom }

  before do
    plan
  end

  describe "initialization" do
    let(:name) { "Week Six" }

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
      periods = FactoryGirl.create_list :period, 3, classroom: classroom
      sorted_periods = periods.sort_by(&:created_at)
      @older, @old, @new = sorted_periods
      expect(@older.id < @new.id).to eq true
    end

    it "throws exception if nil" do
      expect do
        subject.periods_from(nil)
      end.to raise_error
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

  describe '#before?' do
    it "returns true if period is created before the other" do
      p1 = create(:period, created_at: Time.zone.parse("2015-01-01"))
      p2 = create(:period, created_at: Time.zone.parse("2016-01-01"))
      expect(p1).to be_before(p2)
    end
  end
end
