require "spec_helper"

describe Plan do
  let(:name) { "Week Three" }
  subject { FactoryGirl.create(:plan_with_assignments) }

  describe '#template' do
    it "returns a hash of sid to bid mappings" do
      assignments = subject.assignments
      expected = assignments.inject({}) { |acc, a| acc[a.student_id] = a.book_bag_id; acc }
      expect(subject.template).to eq expected
    end
  end

  describe "#assignments" do
    before do
      FactoryGirl.create(:assignment, plan: subject)
    end

    it "returns a list of assignments" do
      expect(subject.assignments).to be_all { |a| a.is_a?(Assignment) }
    end
  end

  describe "#ordered_book_bags" do
    it "returns a list of alpha-sorted book bags" do
      b1 = subject.assignments.first.book_bag
      b2 = subject.assignments.last.book_bag

      b1.update_attributes global_id: "10"
      b2.update_attributes global_id: "1"

      expect(subject.ordered_book_bags).to eq [b2, b1]
    end
  end

  describe "#editable" do
    it "is true if plan is active" do
      expect(subject).to be_editable
    end

    it "is false if inventory state has been created" do
      FactoryGirl.create :inventory_state, period: subject.period
      expect(subject).to_not be_editable
    end
  end

  describe "#active?" do
    it "is active if an inventory state has not been created" do
      expect(subject).to be_active
    end

    it "is false if an inventory state has been recorded" do
      FactoryGirl.create :inventory_state, period: subject.period
      expect(subject).to_not be_active
    end
  end

  describe "#name" do
    it "delegates to period" do
      expect(subject.name).to eq subject.period.name
    end
  end

  describe "initialing a plan" do
    it "also initializes a period" do
      expect(described_class.new.period).to be_instance_of Period
    end

    it "does not init period for existing period" do
      p = FactoryGirl.create :period
      subject.update_attributes(period: p)
      expect(subject.reload.period).to eq p
    end
  end

  describe "period creation after create runs" do
    it "creates a period" do
      expect(subject.period).to be_kind_of Period
      expect(subject.period).to be_persisted
    end
  end
end
