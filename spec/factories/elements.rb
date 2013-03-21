FactoryGirl.define do
  factory :element do
    user
    title { Faker::Lorem.sentence(1) }
  end
end
