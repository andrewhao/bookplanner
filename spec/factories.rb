FactoryGirl.define do
  factory :school do
    classroom
  end

  factory :classroom do
    sequence(:name) { |n| "class#{n}" }
  end

  factory :plan do
    classroom
  end

  factory :plan_with_assignments, parent: :plan do
    after(:build) do |o|
      o.assignments += FactoryGirl.build_list(:assignment, 2, :plan => o)
    end
  end

  factory :inventory_state do
    period
  end

  factory :period do
  end

  factory :student do
    classroom
    sequence(:first_name) {|n| "name#{n}" }
  end

  factory :book_bag do
    sequence(:global_id) {|n| n }
    classroom
  end

  factory :assignment do
    book_bag
    student
  end

  factory :assignment_with_plan, parent: :assignment do
    after(:build) do |o|
      o.plan = FactoryGirl.build :plan, assignments: [o]
    end
  end
end
