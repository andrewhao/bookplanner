FactoryGirl.define do
  factory :school do
    classroom
  end

  factory :classroom do
    sequence(:name) { |n| "class#{n}" }
  end

  factory :plan do
    classroom
    after(:build) do |o|
      o.assignments += FactoryGirl.build_list(:assignment, 2, :plan => o)
    end
  end

  factory :student do
    classroom
  end

  factory :book_bag do
    classroom
  end

  factory :assignment do
    plan
    book_bag
    student
  end
end
