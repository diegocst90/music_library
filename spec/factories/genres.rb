FactoryGirl.define do
  factory :genre do
    name { generate(:random_name) }
    description "Description for Genre"
    
    trait :defined_name do
      name "Genre"
    end
  end
end