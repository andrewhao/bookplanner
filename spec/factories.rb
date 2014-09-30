FactoryGirl.define do
  factory :classroom do
    teacher_name "Ms. Burks"
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
