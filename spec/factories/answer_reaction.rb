FactoryBot.define do
  factory :answer_reaction do
    published_at { Faker::Time.backward(days: 5) }
  end
end
