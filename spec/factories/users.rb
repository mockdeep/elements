FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email    { Faker::Internet.free_email }
    password 'pizza'
    password_confirmation 'pizza'
  end
end
