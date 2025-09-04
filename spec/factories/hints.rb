FactoryBot.define do
  factory :hint do
    association :topic
    body { Faker::Lorem.sentence }
  end
end
