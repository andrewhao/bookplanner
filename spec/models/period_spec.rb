require "spec_helper"

describe Period do
  let(:name)  { "Week Six" }
  subject { FactoryGirl.create :period, name: name }

  describe "initialization" do
    it "prepopulates name to the current time" do
      expect(described_class.new.name).to eq Date.today.to_s
    end

    it "does not prepopulate if the name already exists" do
      expect(subject.name).to eq name
    end
  end
end
