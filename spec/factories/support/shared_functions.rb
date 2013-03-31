FactoryGirl.define do
  sequence(:random_name) {|n| Faker::Name.name + "_#{n}" }
end