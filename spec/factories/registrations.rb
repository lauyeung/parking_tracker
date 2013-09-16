# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration do
    first_name "Joe"
    last_name "Hello"
    sequence(:email) { |n| "joe#{n}@email.com"}
    parking_spot_number 1
  end
end
