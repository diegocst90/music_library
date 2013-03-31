FactoryGirl.define do
  factory :artist do
    name { generate(:random_name) }
    
    trait :defined_name do
      name "Artist"
    end
  end
end