# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    parking_spot_number 1
  end
end
