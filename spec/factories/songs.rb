FactoryGirl.define do
  factory :song do
    name { generate(:random_name) }
    duration "05:53"
    n_album 5
    rating 3
    album
    
    trait :defined_name do
      name "Song"
    end
    
    trait :wrong_duration do
      duration "XXXX"
    end
    
    trait :wrong_n_album do
      n_album 0
    end
    
    trait :too_much_rating do
      rating 7
    end
    
    trait :too_less_rating do
      rating -1
    end
  end
end