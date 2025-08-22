FactoryBot.define do
  factory :answer do
    body { Faker::Quote.yoda.truncate(30)}
    reason {Faker::Lorem.paragraph(sentence_count: 2) }
    published_at { Faker::Time.backward(days: 5) }
  end
end
