FactoryBot.define do
  factory :reaction do
    trait :empathy do
      name { "共感" }
    end
    trait :consent do
      name { "納得" }
    end
    trait :smile do
      name { "爆笑" }
    end
  end
end
