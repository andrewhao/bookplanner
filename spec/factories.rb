FactoryGirl.define do
  factory :school do
    classroom
  end

  factory :classroom do
    name "Ms. Burks"
  end

  factory :plan do
    classroom
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
