require "spec_helper"

describe PlanUpdater do
  let(:plan) { FactoryGirl.create :plan_with_assignments }
  subject { described_class.new(plan) }
end
