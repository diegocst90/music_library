FactoryGirl.define do
  factory :album do
    name { generate(:random_name) }
    year 2000
    image_url nil
    artist
    genre
    
    trait :wrong_year do
      year 1920
    end
    
    trait :defined_name do
      name "Album"
    end
  end
end