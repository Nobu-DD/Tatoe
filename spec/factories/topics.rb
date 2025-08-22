FactoryBot.define do
  factory :topic do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    published_at {Faker::Time.forward(days: 5) }
  end
end
