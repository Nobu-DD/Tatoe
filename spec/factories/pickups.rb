FactoryBot.define do
  factory :pickup do
    start_at { Faker::Time.backward(days: 5) }
    end_at { Faker::Time.forward(days: 5) }
  end
end
